import App from './App'
import {createSSRApp} from 'vue'
import store from './store'
import {register as registerServiceWorker} from './registerServiceWorker'
import './styles/global.scss'
import {checkLogin} from '@/utils/auth.js';
import {ref} from "vue";
import LoginPopup from './components/LoginPopup.vue'; // 引入登录弹窗组件


// 注册Service Worker
registerServiceWorker()

// 不能修改导出的 createApp 方法名，不能修改从 Vue 中导入的 createSSRApp。
export function createApp() {
    const app = createSSRApp(App)
    app.use(store);
    app.component('GlobalLoginPopup', LoginPopup);
    // 挂载全局方法到 uni 实例（方便任意页面调用）
    uni.$openLoginPopup = () => {
        store.commit('openLoginPopup');
    };

    return {
        app,
        store
    }
}

const loginPopup = ref();


// 重写 uni.navigateTo
const originalNavigateTo = uni.navigateTo;
uni.navigateTo = function (options) {
    const url = options.url;
    // 需要登录的页面白名单（根据业务调整）
    const needLoginPages = ['/pages/home'];

    // 检查目标页面是否需要登录
    if (needLoginPages.some(page => url.startsWith(page))) {
        if (!checkLogin(false)) { // 不自动跳转，手动处理
            // 跳转到登录页，并记录原目标 URL
            // originalNavigateTo({
            //   url: `/pages/login?redirect=${encodeURIComponent(url)}`,
            //   ...otherOptions
            // });
            loginPopup.value.openPopup();
            return;
        }
    }

    // 无需登录，正常跳转
    originalNavigateTo(options);
};