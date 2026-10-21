-- =====================================================
-- 订单审核 + 打单发货 重构 阶段1（7/7）：o_order 单号唯一约束降级（父子订单前置条件）
-- 生成日期：2026-10-21
-- 参照：qihang-erp-pro docs/sql/v6/261017b_order_workbench_idempotent_key.sql
--       qihang-erp-pro docs/sql/v6/261018d_order_workbench_fix_uk_index.sql
--       （erp-pro 的演进结论：唯一索引 uk_shop_order_num 对拆分子订单必然撞键，
--         最终降级为普通索引 idx_shop_order_num，幂等改由应用层先查后插保证）
-- 依赖：01 脚本（parent_order_id / source_order_id 已建）
-- 执行时机：必须与 01 同批执行（阶段2拉单落库、阶段3拆单开始前）
-- 幂等：脚本不幂等，仅执行一次
-- =====================================================
--
-- 为什么必须动这个索引（OMS 侧结论，与 erp-pro 一致）：
--   OMS 基线 o_order 上是 UNIQUE KEY `order_sn_index` (`order_num`)，即【全表单号唯一】。
--   新模型下同一平台订单号会产生：主订单 1 行 + 拆分子订单 N 行（order_num 相同，
--   parent_order_id 指向主单），以及合并发货子订单（多单合并后仍沿用各自 order_num）。
--   唯一约束会让阶段3的拆单事务直接插入失败，因此降级为普通索引。
--
-- 影响与配套（阶段2/阶段3 代码需一并收口，不在本脚本处理）：
--   1) 唯一性改由应用层保证：拉单按 (source_order_id, shop_type) 先查后插（见 01 脚本 idx_source_order_id）；
--      主订单定位按 (shop_id, shop_type, order_num, parent_order_id=0) 查询（见本脚本 idx_shop_order_num）。
--   2) 现存按 order_num 单值 selectOne 的写法（如
--      service/src/main/java/cn/qihangerp/service/impl/OfflineOrderServiceImpl.java:215）
--      在出现多行（主单+子单）后会抛 TooManyResultsException，需补 parent_order_id=0 条件
--      或改为列表查询——阶段2改造拉单链路时统一处理。
--   3) 保留 order_num 普通索引（idx_order_num）：既有按单号检索的列表页依赖它，
--      组合索引最左列是 shop_id，单号查询无法命中。
-- =====================================================

ALTER TABLE `o_order`
    DROP INDEX `order_sn_index`,
    ADD INDEX `idx_order_num` (`order_num`) USING BTREE,
    ADD INDEX `idx_shop_order_num` (`shop_id`, `shop_type`, `order_num`, `parent_order_id`) USING BTREE;

-- =====================================================
-- 执行后校验
-- =====================================================

-- SHOW INDEX FROM `o_order` WHERE Key_name IN ('order_sn_index', 'idx_order_num', 'idx_shop_order_num');
-- 预期：order_sn_index 不存在；idx_order_num、idx_shop_order_num 存在（Non_unique=1）。
--
-- 存量库执行前的重复单号体检（有结果说明历史数据已有重复单号，唯一键本就无法维持，照常执行）：
-- SELECT `order_num`, COUNT(*) AS cnt FROM `o_order` GROUP BY `order_num` HAVING COUNT(*) > 1;
