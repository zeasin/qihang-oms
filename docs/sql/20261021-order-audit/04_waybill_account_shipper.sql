-- =====================================================
-- 订单审核 + 打单发货 重构 阶段1（4/7）：面单账号发货主体绑定
-- 生成日期：2026-10-21
-- 参照：qihang-erp-pro docs/sql/v6/261020_waybill_account_subject.sql
-- 依赖：无（o_order.waybill_account_id 在 01 脚本建立）
-- 幂等：脚本不幂等，仅执行一次
--
-- 说明：OMS 已有 oms_shop_waybill_account（点三电子面单物流网点表，docs/qihang-oms.sql），
--       与 erp-pro 同名表逐列比对后仅缺 shipper_type / shipper_id 两列，本脚本补齐。
--       旧 oms_shop_waybill_account_share（网点共享表）本次不迁移、不删除，
--       待统一取号队列切换后再停用。
-- =====================================================

ALTER TABLE `oms_shop_waybill_account`
    ADD COLUMN `shipper_type` INT NOT NULL DEFAULT 0
        COMMENT '发货主体类型（对齐 EnumShipType）：0店铺自用（本地仓）100京东云仓 110吉客云云仓 200系统云仓 300供应商'
        AFTER `merchant_id`,
    ADD COLUMN `shipper_id` BIGINT NOT NULL DEFAULT 0
        COMMENT '发货主体ID：0=店铺自用（本地仓）；供应商/云仓为对应 erp_supplier / erp_warehouse 主键'
        AFTER `shipper_type`;

-- =====================================================
-- 执行后校验
-- =====================================================

-- SHOW COLUMNS FROM `oms_shop_waybill_account` LIKE 'shipper%';
