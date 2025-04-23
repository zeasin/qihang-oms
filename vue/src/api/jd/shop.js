import request from '@/utils/request'

// 获取京东授权url
export function getJdOAuthUrl(query) {
  return request({
    url: '/jd/oauth',
    method: 'get',
    params: query
  })
}

// 获取京东token
export function getJdToken(data) {
  return request({
    url: '/jd/tokenCreate',
    method: 'post',
    data: data
  })
}

