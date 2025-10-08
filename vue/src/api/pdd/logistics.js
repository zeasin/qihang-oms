import request from '@/utils/request'

// 获取PDD发货快递
export function pullLogisticsPdd(data) {
  return request({
    url: '/pdd/logistics/pull_logistics',
    method: 'post',
    data: data
  })
}
