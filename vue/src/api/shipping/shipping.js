import request from '@/utils/request'

// 备货清单
export function listShipOrder(query) {
  return request({
    url: '/ship/stock_up_list',
    method: 'get',
    params: query
  })
}

// 备货清单item-仓库发货
export function listShipStockupItemWarehouse(query) {
  return request({
    url: '/ship/stock_up_list_item_by_warehouse',
    method: 'get',
    params: query
  })
}
// 备货完成
export function shipStockupComplete(data) {
  return request({
    url: '/ship/stock_up_complete',
    method: 'post',
    data: data
  })
}
// 备货完成by order
export function shipStockupCompleteByOrder(data) {
  return request({
    url: '/ship/stock_up_complete_by_order',
    method: 'post',
    data: data
  })
}

// 备货清单-供应商发货
export function listShipStockupSupplier(query) {
  return request({
    url: '/ship/stock_up_list_by_supplier',
    method: 'get',
    params: query
  })
}



export function shipOrderItemSkuIdUpdate(data) {
  return request({
    url: '/ship/order_item_sku_id_update',
    method: 'post',
    data: data
  })
}
