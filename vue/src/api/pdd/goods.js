import request from '@/utils/request'

// 查询列表
export function listGoodsSku(query) {
  return request({
    url: '/pdd/goods/skuList',
    method: 'get',
    params: query
  })
}


export function getGoodsSku(id) {
  return request({
    url: '/pdd/goods/sku/'+id,
    method: 'get',
  })
}


export function linkErpGoodsSkuId(data) {
  return request({
    url: '/pdd/goods/sku/linkErp',
    method: 'post',
    data: data
  })
}

// 接口拉取商品
export function pullGoodsList(data) {
  return request({
    url: '/pdd/goods/pull_goods',
    method: 'post',
    data: data
  })
}
