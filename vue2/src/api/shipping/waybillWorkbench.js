import request from '@/utils/request'

/**
 * 打单发货统一队列（工作台）
 * 后端：WaybillWorkbenchController（/api/erp-api/orderWorkbench/waybill）
 * 队列口径：已放行 + 待发货 + 未发货（合并子单与面单终态已发货/手动发货不入队）
 */

// 队列分页（发货单元平铺，返回 rows / total）
export function pageWaybillOrders(query) {
  return request({
    url: '/api/erp-api/orderWorkbench/waybill/page',
    method: 'get',
    params: query
  })
}

// 队列页签计数（待取号 / 待打印 / 待发货 / 待补分配 / 合计）
export function getWaybillPoolCounts(query) {
  return request({
    url: '/api/erp-api/orderWorkbench/waybill/poolCounts',
    method: 'get',
    params: query
  })
}

// 发货单元详情
export function getWaybillOrderDetail(id) {
  return request({
    url: '/api/erp-api/orderWorkbench/waybill/detail',
    method: 'get',
    params: { id }
  })
}

// 按店铺 + 发货主体查询可用面单账号（分配弹窗数据源）
export function getWaybillAccountOptions(params) {
  return request({
    url: '/api/erp-api/orderWorkbench/waybill/accountOptions',
    method: 'get',
    params
  })
}

// 分配 / 改派面单账号（选中账号即确定发货主体 + 快递 + 网点）
export function distributeWaybill(data) {
  return request({
    url: '/api/erp-api/orderWorkbench/waybill/distribute',
    method: 'post',
    data
  })
}

// 整单退回异常池（必选退回原因标签）
export function returnWaybill(data) {
  return request({
    url: '/api/erp-api/orderWorkbench/waybill/return',
    method: 'post',
    data
  })
}

// 取号（批量，逐单返回成败）
export function takeWaybill(data) {
  return request({
    url: '/api/erp-api/orderWorkbench/waybill/take',
    method: 'post',
    data
  })
}

// 取消取号（批量，已取号未打印 → 未取号，面单账号保留）
export function cancelWaybill(data) {
  return request({
    url: '/api/erp-api/orderWorkbench/waybill/cancel',
    method: 'post',
    data
  })
}

// 打印（批量，仅推进面单状态 已取号 → 已打印，物理打印由本地打印组件负责）
export function printWaybill(data) {
  return request({
    url: '/api/erp-api/orderWorkbench/waybill/print',
    method: 'post',
    data
  })
}

// 发货（批量，平台面单链路回传平台并置已发货）
export function shipWaybill(data) {
  return request({
    url: '/api/erp-api/orderWorkbench/waybill/ship',
    method: 'post',
    data
  })
}

// 手动发货（单单：人工录入物流公司 + 快递单号，兜底通道）
export function manualShipWaybill(data) {
  return request({
    url: '/api/erp-api/orderWorkbench/waybill/manualShip',
    method: 'post',
    data
  })
}

// 平台电子面单动作能力（取号 / 取消取号 / 打印 / 发货回传）
export function getWaybillCapabilities(shopType) {
  return request({
    url: '/api/erp-api/orderWorkbench/waybill/capabilities',
    method: 'get',
    params: { shopType }
  })
}

// 异常池分类标签（退回原因数据源，复用订单审核工作台标签接口 bind_pool=2）
export function getWaybillReturnTagOptions(bindPool) {
  return request({
    url: '/api/erp-api/orderWorkbench/tag/poolOptions',
    method: 'get',
    params: { bindPool }
  })
}

// 状态漂移自检（o_order.waybill_status 与打单记录一致性比对，返回 items / truncated）
export function driftDetect() {
  return request({
    url: '/api/erp-api/orderWorkbench/waybill/drift',
    method: 'get'
  })
}

// 状态漂移修复（批量，逐单重新检测确认后按类型修复，返回 successCount / failCount / items）
export function driftFix(data) {
  return request({
    url: '/api/erp-api/orderWorkbench/waybill/fixDrift',
    method: 'post',
    data
  })
}
