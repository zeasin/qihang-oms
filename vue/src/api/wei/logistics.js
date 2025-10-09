import request from '@/utils/request'


// 接口拉取Wei快递
export function pullLogisticsWei(data) {
  return request({
    url: '/wei/logistics/pull_logistics',
    method: 'post',
    data: data
  })
}
