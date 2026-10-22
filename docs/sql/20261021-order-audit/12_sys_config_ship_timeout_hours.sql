-- =====================================================
-- 打单发货/审单工作台 超时预警：发货超时预警时效初始化
-- 生成日期：2026-10-23
-- 参照：05_sys_config_manual_audit.sql（同为 sys_config 幂等初始化）
-- 口径：队列/审单池按 create_time 与 now-N 小时比较，
--       剩余 <0 计已超时，剩余 0~12 小时计即将超时（12 为代码常量，非本配置）。
-- 幂等：按 config_key 判存在，可重复执行
-- =====================================================

INSERT INTO `sys_config`
    (`config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `remark`)
SELECT '发货超时预警时效(小时)',
       'order.ship.timeout.hours',
       '48',
       'Y',
       'admin',
       NOW(),
       '订单自创建起 N 小时内应完成发货；队列/审单池按 create_time+N 计算剩余时效，剩余<0=已超时，剩余0~12小时=即将超时'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sys_config` WHERE `config_key` = 'order.ship.timeout.hours');

-- =====================================================
-- 执行后校验
-- =====================================================

-- SELECT `config_id`, `config_key`, `config_value`, `remark`
-- FROM `sys_config` WHERE `config_key` = 'order.ship.timeout.hours';
