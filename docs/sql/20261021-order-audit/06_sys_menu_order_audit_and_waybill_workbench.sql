-- =====================================================
-- 订单审核 + 打单发货 重构 阶段1（6/7）：菜单与按钮权限
-- 生成日期：2026-10-21
-- 参照：qihang-erp-pro docs/sql/v6/261018e_order_workbench_menu.sql
--       qihang-erp-pro docs/sql/v6/261020b_waybill_workbench_menu.sql
--       qihang-erp-pro docs/sql/v6/261020d_waybill_workbench_take_cancel_menu.sql
--       qihang-erp-pro docs/sql/v6/261020e_waybill_workbench_print_ship_menu.sql
-- 依赖：无（纯新增 sys_menu 行；o_order 字段由 01 脚本提供）
-- 幂等：使用 INSERT IGNORE + 显式 menu_id，重复执行不产生重复行
--
-- 挂载点确认（依据 docs/qihang-oms.sql sys_menu 现有数据行，共 48 行，最大 menu_id=2173，
-- 表 AUTO_INCREMENT=2176，因此本脚本从 2200 起占用，完全避开已用区间）：
--   menu_id=1 【订单管理】一级目录（parent_id=0，path=/sale）
--             子节点：100 订单库、193 订单明细、102 店铺订单、155 手动添加店铺订单
--   menu_id=8 【发货管理】一级目录（parent_id=0，path=ship）
--             子节点：857 手动发货、894 打单发货(旧 shipping/ewaybillPrint/index1.vue)、
--                     840 供应商发货、841/2171 云仓发货、889 发货记录、884 电子面单设置、2173 发货快递设置
--   → 订单审核挂 parent_id=1，打单发货挂 parent_id=8
--
-- 命名说明：新菜单沿用产品口径名称「打单发货」（path=waybillWorkbench，
--   component=shipping/waybillWorkbench/index，perms=orderWorkbench:waybill:list）。
--   它与既有 menu_id=894 的旧「打单发货」页面并存：旧页面本期【不改动、不下线】，
--   新队列按 order_num/order_id 灰度接管，待阶段4后端链路验证通过后由后续脚本停用旧菜单。
--   order_num 取 10，紧邻旧菜单（11）之前展示。
-- =====================================================

-- =====================================================
-- 一、订单审核（状态池工作台：待审核/异常/已审核/已拆单）
-- =====================================================

INSERT IGNORE INTO `sys_menu`
    (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`,
     `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES (2200, '订单审核', 1, 5, 'orderWorkbench', 'order/workbench/index', NULL, 1, 0,
        'C', '0', '0', 'orderWorkbench:order:list', 'checkbox', 'admin', NOW(), '', NULL,
        '订单审核工作台（状态池/标签/放行/转异常/撤回/拆单）');

-- =====================================================
-- 二、打单发货统一队列 + 按钮权限
-- =====================================================

INSERT IGNORE INTO `sys_menu`
    (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`,
     `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES (2201, '打单发货', 8, 10, 'waybillWorkbench', 'shipping/waybillWorkbench/index', NULL, 1, 0,
        'C', '0', '0', 'orderWorkbench:waybill:list', 'print', 'admin', NOW(), '', NULL,
        '打单发货统一队列（面单账号分配/退回异常池/取号/取消/打印/发货/手动发货）');

-- 按钮权限（parent_id=2201，顺序与队列页操作流一致）
INSERT IGNORE INTO `sys_menu`
    (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`,
     `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES (2202, '面单账号分配', 2201, 1, '#', '', NULL, 1, 0, 'F', '0', '0',
        'orderWorkbench:waybill:distribute', '#', 'admin', NOW(), '', NULL, '分配/改派发货主体与面单账号'),
       (2203, '整单退回异常池', 2201, 2, '#', '', NULL, 1, 0, 'F', '0', '0',
        'orderWorkbench:waybill:return', '#', 'admin', NOW(), '', NULL, '清空发货主体与面单账号，回异常池并打分类标签'),
       (2204, '电子面单取号', 2201, 3, '#', '', NULL, 1, 0, 'F', '0', '0',
        'orderWorkbench:waybill:take', '#', 'admin', NOW(), '', NULL, '按已分配面单账号向平台取号（waybill_status 0→1）'),
       (2205, '取消取号', 2201, 4, '#', '', NULL, 1, 0, 'F', '0', '0',
        'orderWorkbench:waybill:cancel', '#', 'admin', NOW(), '', NULL, '打印/发货前取消平台取号并回未取号（1→0）'),
       (2206, '面单打印', 2201, 5, '#', '', NULL, 1, 0, 'F', '0', '0',
        'orderWorkbench:waybill:print', '#', 'admin', NOW(), '', NULL, '已取号订单标记为已打印（1→2）'),
       (2207, '面单发货', 2201, 6, '#', '', NULL, 1, 0, 'F', '0', '0',
        'orderWorkbench:waybill:ship', '#', 'admin', NOW(), '', NULL, '已打印订单回传平台并发货（2→3），本地仓生成备货单'),
       (2208, '手动发货', 2201, 7, '#', '', NULL, 1, 0, 'F', '0', '0',
        'orderWorkbench:waybill:manualShip', '#', 'admin', NOW(), '', NULL,
        '无面单账号/线下已寄出订单人工填单号发货，按能力回传平台（waybill_status=10）');

-- =====================================================
-- 三、角色授权提醒（本脚本不改 sys_role_menu，避免越权批量授权）
-- =====================================================
-- 部署后需在【系统设置-角色管理】为总部/商户运营角色勾选上述菜单与按钮权限；
-- 店铺端仅查看队列，不勾选 2203 退回异常池 与 2208 手动发货。

-- =====================================================
-- 执行后校验
-- =====================================================

-- SELECT `menu_id`, `menu_name`, `parent_id`, `menu_type`, `path`, `component`, `perms`
-- FROM `sys_menu` WHERE `menu_id` BETWEEN 2200 AND 2208 ORDER BY `menu_id`;
-- SELECT `menu_id`, `menu_name`, `parent_id`, `perms` FROM `sys_menu` WHERE `perms` LIKE 'orderWorkbench:%';
