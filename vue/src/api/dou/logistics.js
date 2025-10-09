import request from '@/utils/request'

// 获取DOU发货快递
export function pullLogisticsDou(data) {
  return request({
    url: '/dou/logistics/pull_logistics',
    method: 'post',
    data: data
  })
}
