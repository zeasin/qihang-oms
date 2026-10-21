-- =====================================================
-- 订单审核 + 打单发货 重构 阶段1（5/7）：人工审单开关初始化
-- 生成日期：2026-10-21
-- 参照：qihang-erp-pro docs/sql/v6/261017_order_workbench_phase1_rebuild.sql §五
--       qihang-erp-pro docs/sql/v6/261018g_order_workbench_index_and_audit_default.sql
-- 依赖：01 脚本（o_order.audit_status 已建列）
-- 幂等：按 config_key 判存在，可重复执行
--
-- ⚠ OMS 与 erp-pro 的默认值相反，务必看清原因：
--   erp-pro：order.manual_audit.enabled = 'false'，新订单落库即放行（audit_status=1），
--            审单工作台是可选加速通道。
--   OMS   ：产品要求【订单进来必须经过审核】，因此默认 'true'（人工审核），
--            拉单/手工建单链路落 o_order 时显式写 audit_status=0（EnumAuditStatus.PENDING）进入待审核池，
--            只有审单放行（或自动规则放行）后才置 1，未放行订单不允许取号/发货。
--   库列默认值仍保留 1（见 01 脚本）：与 erp-pro 一致的兜底策略——
--            新审核字段只由审单链路显式赋值，老入口（POS/手工单/对接方直插）不写审核字段时
--            落 1 放行，避免这些单落库即挂待审核池并被发货门禁永久挡住。
--            新增建单入口必须走 applyAuditInit 显式赋值，不得依赖库默认值。
-- =====================================================

INSERT INTO `sys_config`
    (`config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `remark`)
SELECT '订单人工审单开关',
       'order.manual_audit.enabled',
       'true',
       'Y',
       'admin',
       NOW(),
       'true=新订单落库即进入待审核池(audit_status=0)，必须人工/规则放行后才能打单发货（OMS 默认）；false=新订单自动放行(audit_status=1)'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_config` WHERE `config_key` = 'order.manual_audit.enabled');

-- =====================================================
-- 执行后校验
-- =====================================================

-- SELECT `config_id`, `config_key`, `config_value`, `remark`
-- FROM `sys_config` WHERE `config_key` = 'order.manual_audit.enabled';
