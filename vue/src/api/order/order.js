import request from '@/utils/request'

// 查询店铺订单列表
export function listOrder(query) {
  return request({
    url: '/order/list',
    method: 'get',
    params: query
  })
}
// 查询待自己发货的订单列表（待发货的）
export function waitShipmentList(query) {
  return request({
    url: '/order/waitShipmentList',
    method: 'get',
    params: query
  })
}


// 手动发货
export function manualShipmentOrder(data) {
  return request({
    url: '/order/manualShipment',
    method: 'post',
    data: data
  })
}

// 分配供应商发货
export function allocateShipmentOrder(data) {
  return request({
    url: '/order/allocateShipmentOrder',
    method: 'post',
    data: data
  })
}

// 查询店铺订单详细
export function getOrder(id) {
  return request({
    url: '/order/' + id,
    method: 'get'
  })
}

// 订单明细list
export function listOrderItem(query) {
  return request({
    url: '/order/item_list',
    method: 'get',
    params: query
  })
}

export function updateErpSkuId(data) {
  return request({
    url: '/order/updateErpSkuId',
    method: 'post',
    data: data
  })
}



// 新增店铺订单
export function addOrder(data) {
  return request({
    url: '/order/add',
    method: 'post',
    data: data
  })
}
// 取消订单
export function cancelOrder(data) {
  return request({
    url: '/order/cancelOrder',
    method: 'post',
    data: data
  })
}
export function orderItemSpecIdUpdate(data) {
  return request({
    url: '/order/order_item_sku_id_update',
    method: 'post',
    data: data
  })
}
