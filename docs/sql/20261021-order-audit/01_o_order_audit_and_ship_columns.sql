-- =====================================================
-- 订单审核 + 打单发货 重构 阶段1（1/7）：o_order 审核字段 / 父子订单 / 面单账号 / 平台回传
-- 生成日期：2026-10-21
-- 参照：qihang-erp-pro docs/sql/v6/261017_order_workbench_phase1_rebuild.sql
--       qihang-erp-pro docs/sql/v6/261018g_order_workbench_index_and_audit_default.sql
--       qihang-erp-pro docs/sql/v6/261020_waybill_account_subject.sql
-- 适用库：qihang-oms（OMS 业务库），脚本不绑定库名
-- 依赖：无（本批次首篇）；执行顺序 01 → 02 → 03 → 04 → 05 → 06 → 07
-- 幂等：脚本不幂等，仅执行一次（重复执行报 Duplicate column name）
--
-- 与 erp-pro 的口径差异（重要）：
--   erp-pro 的 source_order_id 是 BIGINT「拆分来源订单ID」；
--   OMS 是「平台分表落地」架构（oms_tao_order / oms_dou_order / oms_pdd_order /
--   oms_wei_order / oms_shop_order … 每张落地表各自自增主键），因此本项目的
--   source_order_id 定义为 VARCHAR：存【平台落地表订单主键】，是拉单落 o_order 的
--   幂等判重依据，判重口径为 (source_order_id, shop_type)，不建唯一索引（同一平台单
--   拆单后会产生多行同 source_order_id 的记录），由应用层「先查后插」保证幂等。
-- =====================================================

-- =====================================================
-- 一、父子订单关系（拆单/合单后的订单角色）
-- =====================================================

ALTER TABLE `o_order`
    ADD COLUMN `parent_order_id` BIGINT NOT NULL DEFAULT 0
        COMMENT '父订单ID：子订单指向主订单；主订单固定为0（非NULL，便于等值检索）'
        AFTER `id`,
    ADD COLUMN `order_role` INT NOT NULL DEFAULT 0
        COMMENT '订单角色（EnumOrderRole）：0=主订单MASTER，1=子订单CHILD，2=合并发货子订单MERGE_CHILD'
        AFTER `parent_order_id`,
    ADD COLUMN `source_order_id` VARCHAR(64) NULL
        COMMENT '平台落地表订单主键（oms_tao_order / oms_dou_order / oms_pdd_order / oms_wei_order / oms_shop_order 等表的 id），拉单幂等判重键，判重口径 source_order_id + shop_type；拆分子订单继承来源主订单的值'
        AFTER `order_role`;

-- =====================================================
-- 二、审核字段（订单状态池筛选依据）
-- 状态值一律走枚举，禁止裸魔法数字：
--   EnumAuditStatus：0=待审核 1=已审核通过 2=已转异常 3=已拆单（主订单拆单后终态，退出全部状态池）
--   EnumAuditType ：0=自动审核 1=人工审核
-- =====================================================

ALTER TABLE `o_order`
    ADD COLUMN `audit_status` INT NOT NULL DEFAULT 1
        COMMENT '审核状态（EnumAuditStatus）：0=待审核，1=已审核通过，2=已转异常，3=已拆单；库默认1（详见 05 脚本说明：OMS 人工审单开关默认开启，建单/拉单链路落库时显式置0）'
        AFTER `order_status`,
    ADD COLUMN `audit_type` INT NOT NULL DEFAULT 0
        COMMENT '审核类型（EnumAuditType）：0=自动审核，1=人工审核'
        AFTER `audit_status`,
    ADD COLUMN `audit_time` DATETIME NULL
        COMMENT '最近一次审核/放行时间'
        AFTER `audit_type`,
    ADD COLUMN `audit_by` VARCHAR(50) NULL
        COMMENT '审核/放行操作人用户名'
        AFTER `audit_time`,
    ADD COLUMN `audit_remark` VARCHAR(500) NULL
        COMMENT '审核/放行备注（转异常原因、撤回原因等写这里）'
        AFTER `audit_by`;

-- =====================================================
-- 三、打单发货：面单账号 + 平台回传字段
-- 复用已有 waybill_code / waybill_company，不新增同义的 shipping_number、shipping_company。
-- waybill_status（已有列，EnumWaybillStatus：0未取号1已取号2已打印3已发货10手动发货）不动。
-- =====================================================

ALTER TABLE `o_order`
    ADD COLUMN `waybill_order_id` VARCHAR(35) NULL
        COMMENT '平台电子面单订单标识（取号回执，视频号等平台需要）'
        AFTER `waybill_company`,
    ADD COLUMN `shipping_company_code` VARCHAR(25) NULL
        COMMENT '快递公司编码（与 o_order_ship_waybill.logistics_code 同源，冗余到订单便于队列检索）'
        AFTER `waybill_order_id`,
    ADD COLUMN `waybill_account_id` BIGINT NULL DEFAULT NULL
        COMMENT '面单账号ID（oms_shop_waybill_account.id）：审单分配发货主体时写入，取号沿用'
        AFTER `waybill_status`,
    ADD COLUMN `platform_ship_status` INT NULL
        COMMENT '平台回传发货状态（平台侧原始口径，与内部 ship_status / audit_status 完全分离，勿混用）'
        AFTER `shipping_company_code`,
    ADD COLUMN `platform_ship_result` VARCHAR(1000) NULL
        COMMENT '平台回传结果摘要（成功回执或失败原因，供工作台展示与重试判断）'
        AFTER `platform_ship_status`;

-- =====================================================
-- 四、索引
-- =====================================================

ALTER TABLE `o_order`
    ADD INDEX `idx_audit_status` (`audit_status`, `order_status`) USING BTREE,
    ADD INDEX `idx_ship_status` (`ship_status`, `audit_status`) USING BTREE,
    ADD INDEX `idx_parent_order_id` (`parent_order_id`) USING BTREE,
    ADD INDEX `idx_waybill_account_id` (`waybill_account_id`) USING BTREE,
    ADD INDEX `idx_source_order_id` (`source_order_id`, `shop_type`) USING BTREE;

-- 说明：
--   idx_audit_status       —— 待审核池/异常池按审核状态 + 订单状态翻页；
--   idx_ship_status        —— 打单发货队列按 ship_status + audit_status 取待处理单；
--   idx_parent_order_id    —— 拆单/合并/取消/改址按父订单汇总有效子订单；
--   idx_waybill_account_id —— 按面单账号统计余额占用与队列分派；
--   idx_source_order_id    —— 拉单幂等「先查后插」（source_order_id + shop_type），
--                             普通索引不判重，唯一性由应用层保证。

-- =====================================================
-- 五、存量数据回填（存量库执行；干净基线库无数据可跳过）
-- 历史订单没有经过新审核链路，统一视为已审核通过（EnumAuditStatus.APPROVED=1）、
-- 自动审核（EnumAuditType.AUTO=0），操作人记 system，避免历史单大量落在待审核池。
-- =====================================================

UPDATE `o_order`
SET `audit_status` = 1,
    `audit_type`   = 0,
    `audit_time`   = `create_time`,
    `audit_by`     = 'system',
    `audit_remark` = '历史订单自动审核通过（阶段1初始化）'
WHERE `audit_time` IS NULL;

-- 历史订单均为主订单：parent_order_id 已由列默认值取 0，order_role 取 0（EnumOrderRole.MASTER）。

-- =====================================================
-- 六、执行后校验
-- =====================================================

-- SHOW COLUMNS FROM `o_order` LIKE '%audit%';
-- SHOW COLUMNS FROM `o_order` LIKE '%shipper%';
-- SHOW INDEX FROM `o_order`;
-- SELECT `audit_status`, COUNT(*) FROM `o_order` GROUP BY `audit_status`;
