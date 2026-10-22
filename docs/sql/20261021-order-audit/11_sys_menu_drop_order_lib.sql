-- 订单管理二级菜单下线「订单库」（menu_id=100），只保留「订单审核」（menu_id=2200）
-- 订单审核页"全部"tab 口径已覆盖旧订单库全量查询，旧入口不再保留
DELETE FROM sys_role_menu WHERE menu_id = 100;
DELETE FROM sys_menu WHERE menu_id = 100;
