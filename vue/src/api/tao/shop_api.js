import request from '@/utils/request'



// jd快递公司
export function pullLogisticsJd(data) {
  return request({
    url: '/api/jd-api/shopApi/pull_logistics_companies',
    method: 'post',
    data: data
  })
}
export function getTaoOAuthUrl(query) {
  return request({
    url: '/tao/oauth',
    method: 'get',
    params: query
  })
}

export function saveSessionKey(data) {
  return request({
    url: '/tao/saveSessionKey',
    method: 'post',
    data: data
  })
}
