import request from '@/utils/request'


// 接口拉取淘宝快递
export function pullLogisticsTao(data) {
  return request({
    url: '/tao/logistics/pull_logistics',
    method: 'post',
    data: data
  })
}
