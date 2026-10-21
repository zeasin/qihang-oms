-- =====================================================
-- 打单发货统一队列 阶段4b（1/2）：o_order 发货时间列补齐
-- 生成日期：2026-10-21
-- 参照：qihang-erp-pro o_order.shipping_time（docs/design/16-打单发货.md §1.1）
-- 依赖：01_o_order_audit_and_ship_columns.sql（waybill_status / waybill_account_id 已建）
-- 幂等：脚本不幂等，仅执行一次
--
-- 说明：OMS 实体 OOrder.shippingTime 历史上被注释掉（旧发货链路用 o_order_stocking.shipping_time），
--       统一队列 saveShipResult 需要订单侧发货时间权威字段，本脚本补列并恢复实体字段。
-- =====================================================

ALTER TABLE `o_order`
    ADD COLUMN `shipping_time` datetime DEFAULT NULL
        COMMENT '实际发货时间（打单发货/手动发货成功时写入）'
        AFTER `ship_status`;

-- =====================================================
-- 执行后校验
-- =====================================================

-- SHOW COLUMNS FROM `o_order` LIKE 'shipping_time';
