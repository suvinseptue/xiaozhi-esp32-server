import App from './App'
import { createSSRApp } from 'vue'
import store from './store'
import { register as registerServiceWorker } from './registerServiceWorker'
import './styles/global.scss'

// 注册Service Worker
registerServiceWorker()

// 不能修改导出的 createApp 方法名，不能修改从 Vue 中导入的 createSSRApp。
export function createApp() {
  const app = createSSRApp(App)
  app.use(store)
  return {
      app
  }
}
