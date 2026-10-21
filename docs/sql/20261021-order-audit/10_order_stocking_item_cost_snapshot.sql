-- =====================================================
-- 打单发货统一队列 阶段4b（2/2）：o_order_stocking_item 成本快照列补齐
-- 生成日期：2026-10-21
-- 参照：qihang-erp-pro docs/sql/v6/261021_stocking_item_cost_snapshot.sql（成本口径②）
-- 依赖：无
-- 幂等：脚本不幂等，仅执行一次
--
-- 说明：备货明细插行时写入 unit_cost = o_goods_sku.unit_cost 当时值、total_cost = unit_cost × quantity；
--       OMS o_order_stocking_item 无 batch_num 列（erp-pro 有），成本列改挂 quantity 之后。
--       档案无成本值时两列留 NULL = 成本③未维护（利润取数优先级 ①→②→③）。
-- =====================================================

ALTER TABLE `o_order_stocking_item`
    ADD COLUMN `unit_cost`  decimal(10, 2) NULL DEFAULT NULL
        COMMENT '单位成本快照(o_goods_sku.unit_cost 插行时值)' AFTER `quantity`,
    ADD COLUMN `total_cost` decimal(10, 2) NULL DEFAULT NULL
        COMMENT '总成本快照(unit_cost × quantity)' AFTER `unit_cost`;

-- =====================================================
-- 执行后校验
-- =====================================================

-- SHOW COLUMNS FROM `o_order_stocking_item` LIKE '%cost%';
