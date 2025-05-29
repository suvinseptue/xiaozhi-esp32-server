import { getServiceUrl } from '../api'
import RequestService from '../httpRequest'


export default {
    // 登录
    login(loginForm, callback) {
        RequestService.sendRequest()
            .url(`${getServiceUrl()}/wechat/login`)
            .method('POST')
            .data(loginForm)
            .success((res) => {
                RequestService.clearRequestTime()
				console.log('请求服务端登录成功:', res.data)
                callback(res.data)
            })
            .fail(() => {
                RequestService.reAjaxFun(() => {
                    this.login(code, callback)
                })
            }).send()
    }
}
