-- =====================================================
-- 订单审核 + 打单发货 重构 阶段1（2/7）：o_order_item 商品行角色
-- 生成日期：2026-10-21
-- 参照：qihang-erp-pro docs/sql/v6/261017_order_workbench_phase1_rebuild.sql §三
-- 依赖：无（可与 01 并行，但按编号顺序执行）
-- 幂等：脚本不幂等，仅执行一次
--
-- 说明（OMS 与 erp-pro 的差异）：
--   erp-pro 本批次还给 o_order_item 加了 source_order_item_id / sort_no，
--   OMS 本次【不加】：OMS 拆单来源追溯按订单粒度（o_order.source_order_id）即可满足，
--   行序沿用主键 id 排序；后续如工作台需要自定义行序再补列，避免一次性引入无人消费字段。
--   shipper_id / shipper_no / shipper_type / shipper_name / refund_count 在 OMS 基线
--   （docs/qihang-oms.sql o_order_item）中已存在，本脚本不重复添加。
-- =====================================================

ALTER TABLE `o_order_item`
    ADD COLUMN `item_role` INT NOT NULL DEFAULT 0
        COMMENT '商品行角色（EnumOrderRole 同口径）：0=主订单原始行，1=子订单履约行，2=合并发货子订单行'
        AFTER `id`;

-- =====================================================
-- 存量数据：历史商品行全部属于主订单原始行
-- =====================================================

UPDATE `o_order_item` SET `item_role` = 0 WHERE `item_role` <> 0;

-- =====================================================
-- 执行后校验
-- =====================================================

-- SHOW COLUMNS FROM `o_order_item` LIKE 'item_role';
