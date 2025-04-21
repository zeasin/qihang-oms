import request from '@/utils/request'

// 查询店铺订单列表
export function listOrder(query) {
  return request({
    url: '/order/list',
    method: 'get',
    params: query
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

export function shipOrder(data) {
  return request({
    url: '/api/order/ship',
    method: 'post',
    data: data
  })
}

export function pushErp(id) {
  return request({
    url: '/order/pushErp/' + id,
    method: 'post'
  })
}

// 新增店铺订单
export function addOrder(data) {
  return request({
    url: '/order',
    method: 'post',
    data: data
  })
}
