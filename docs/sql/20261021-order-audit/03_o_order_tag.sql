-- =====================================================
-- 订单审核 + 打单发货 重构 阶段1（3/7）：订单标签字典 o_order_tag
-- 生成日期：2026-10-21
-- 参照：qihang-erp-pro docs/sql/v6/261018_order_workbench_phase2_tag_scheme.sql（仅 tag 部分）
--       qihang-erp-pro docs/sql/v6/261019_order_tag_pool.sql（bind_pool）
-- 依赖：无
-- 幂等：CREATE TABLE IF NOT EXISTS，可重复执行
--
-- 范围说明：erp-pro 同批次的检索方案表 o_order_search_scheme 本次【不做】，
--          留待工作台后续阶段；打标数据存 o_order.tag（复用现有 varchar(100) 列，不改 o_order）。
-- =====================================================

CREATE TABLE IF NOT EXISTS `o_order_tag` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '标签id，自增',
  `name` varchar(50) NOT NULL COMMENT '标签名称（如：发供应商A/顺丰/断货跟进）',
  `color` varchar(20) NOT NULL DEFAULT '' COMMENT '标签颜色（预置10色色板色值，如#6366F1）',
  `merchant_id` bigint NOT NULL DEFAULT '0' COMMENT '商户ID（0=总部公共标签，商户端可见可用）',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序号，越小越靠前',
  `bind_pool` int NOT NULL DEFAULT '0' COMMENT '关联状态池（对齐 o_order.audit_status / EnumAuditStatus：0=通用标签不挂池，2=异常池分类标签）；转异常时必选一个 bind_pool=2 的标签并覆盖写入订单 tag，异常池页签按分类实时计数',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态（0禁用1启用）；停用标签不再出现在打标选项，已打订单保留数据',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` varchar(25) NOT NULL DEFAULT '' COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(25) DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_merchant_status` (`merchant_id`, `status`, `sort`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='订单处理工作台-订单标签字典（用户自建）';

-- =====================================================
-- 执行后校验
-- =====================================================

-- SHOW TABLES LIKE 'o_order_tag';
-- SHOW INDEX FROM `o_order_tag`;
