import request from '@/utils/request'

// 订单处理工作台接口封装
// 后端：cn.qihangerp.api.controller.workbench.{WorkbenchOrderController,WorkbenchSplitController,WorkbenchTagController}
// 路由前缀统一为 /api/erp-api/orderWorkbench（末段与 erp-pro 对齐）

// ==================== 订单域（/orderWorkbench/order） ====================

// 状态池分页查询（主订单行 + 内嵌子订单行，含 canRelease）
export function poolPage(query) {
  return request({
    url: '/api/erp-api/orderWorkbench/order/page',
    method: 'get',
    params: query
  })
}

// 状态池计数（页签角标）
export function poolCounts(query) {
  return request({
    url: '/api/erp-api/orderWorkbench/order/poolCounts',
    method: 'get',
    params: query
  })
}

// 异常池分类计数（bind_pool=2 标签聚合 + 未分类兜底）
export function exceptionTagCounts(query) {
  return request({
    url: '/api/erp-api/orderWorkbench/order/exceptionTagCounts',
    method: 'get',
    params: query
  })
}

// 批量转异常/转正常（target：0转正常 2转异常；target=2 需带 tagId 分类标签）
export function toException(data) {
  return request({
    url: '/api/erp-api/orderWorkbench/order/exception',
    method: 'post',
    data: data
  })
}

// 批量审核放行（逐单返回结果，部分失败留池）
export function releaseOrders(data) {
  return request({
    url: '/api/erp-api/orderWorkbench/order/release',
    method: 'post',
    data: data
  })
}

// 已放行订单撤回异常池（整单退回，未发货前置）
export function withdrawToException(data) {
  return request({
    url: '/api/erp-api/orderWorkbench/order/withdrawException',
    method: 'post',
    data: data
  })
}

// 取消订单（主订单级，未发货前置）
export function cancelWorkOrder(data) {
  return request({
    url: '/api/erp-api/orderWorkbench/order/cancel',
    method: 'post',
    data: data
  })
}

// 修改卖家备注
export function updateOrderMemo(data) {
  return request({
    url: '/api/erp-api/orderWorkbench/order/memo',
    method: 'post',
    data: data
  })
}

// 修改收货地址
export function updateOrderAddress(data) {
  return request({
    url: '/api/erp-api/orderWorkbench/order/address',
    method: 'post',
    data: data
  })
}

// 分店铺电子面单账号选项（放行弹窗数据源）
export function waybillAccountOptions(query) {
  return request({
    url: '/api/erp-api/orderWorkbench/order/waybillAccountOptions',
    method: 'get',
    params: query
  })
}

// ==================== 标签（/orderWorkbench/tag） ====================

// 标签管理分页列表
export function listTags(query) {
  return request({
    url: '/api/erp-api/orderWorkbench/tag/list',
    method: 'get',
    params: query
  })
}

// 启用标签下拉（打标弹窗：商户自建 + 总部公共）
export function tagOptions() {
  return request({
    url: '/api/erp-api/orderWorkbench/tag/options',
    method: 'get'
  })
}

// 状态池分类标签下拉（转异常弹窗单选：bind_pool 匹配 + 启用，全系统共用）
export function poolTagOptions(bindPool) {
  return request({
    url: '/api/erp-api/orderWorkbench/tag/poolOptions',
    method: 'get',
    params: { bindPool }
  })
}

// 新增标签
export function addTag(data) {
  return request({
    url: '/api/erp-api/orderWorkbench/tag',
    method: 'post',
    data: data
  })
}

// 修改标签
export function editTag(data) {
  return request({
    url: '/api/erp-api/orderWorkbench/tag',
    method: 'put',
    data: data
  })
}

// 标签停用/启用
export function setTagStatus(data) {
  return request({
    url: '/api/erp-api/orderWorkbench/tag/status',
    method: 'put',
    data: data
  })
}

// 标签删除（物理删除）
export function deleteTag(id) {
  return request({
    url: '/api/erp-api/orderWorkbench/tag/' + id,
    method: 'delete'
  })
}

// 批量打标/撤标（action：1打标 0撤标；orderIds 为字符串ID列表）
export function applyTags(data) {
  return request({
    url: '/api/erp-api/orderWorkbench/tag/apply',
    method: 'post',
    data: data
  })
}

// ==================== 拆单（/orderWorkbench/split） ====================

// 拆单预览（含重新拆分恢复数据）
export function splitPreview(orderId) {
  return request({
    url: '/api/erp-api/orderWorkbench/split/preview',
    method: 'get',
    params: { orderId }
  })
}

// 提交拆单
export function splitSubmit(data) {
  return request({
    url: '/api/erp-api/orderWorkbench/split/submit',
    method: 'post',
    data: data
  })
}
