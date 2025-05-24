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
                callback(res)
            })
            .fail(() => {
                RequestService.reAjaxFun(() => {
                    this.login(loginForm, callback)
                })
            }).send()
    }
}
