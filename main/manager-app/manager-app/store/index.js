import { goToPage } from "@/utils";
import { createStore } from 'vuex'
import Api from '../apis/api';
import Constant from '../utils/constant';
import {Storage} from "../utils/storage";

const store = createStore({
  state: {
    token: '',
    userInfo: {}, // 添加用户信息存储
    isSuperAdmin: false, // 添加superAdmin状态
    pubConfig: { // 添加公共配置存储
      version: '',
      allowUserRegister: false
    },
    showLoginPopup: false
  },
  getters: {
    getToken(state) {
      if (!state.token) {
        state.token = Storage.getSync('token')
      }
      return state.token
    },
    getUserInfo(state) {
      return state.userInfo
    },
    getIsSuperAdmin(state) {
      if (Storage.getSync('isSuperAdmin') === null) {
        return state.isSuperAdmin
      }
      return Storage.getSync('isSuperAdmin') === 'true'
    },
    getPubConfig(state) {
      return state.pubConfig
    }
  },
  mutations: {
    setToken(state, token) {
      state.token = token
      Storage.setSync('token', token,30*60*1000)
    },
    setUserInfo(state, userInfo) {
      state.userInfo = userInfo
      const isSuperAdmin = userInfo.superAdmin === 1
      state.isSuperAdmin = isSuperAdmin
      Storage.setSync('isSuperAdmin', isSuperAdmin,30*60*1000)
    },
    setPubConfig(state, config) {
      state.pubConfig = config
    },
    clearAuth(state) {
      state.token = ''
      state.userInfo = {}
      state.isSuperAdmin = false
      Storage.removeSync('token')
      Storage.removeSync('isSuperAdmin')
    },
    // 打开登录弹窗
    openLoginPopup(state) {
      state.showLoginPopup = true;
    },
    // 关闭登录弹窗
    closeLoginPopup(state) {
      state.showLoginPopup = false;
    },
  },
  actions: {
    // 添加 logout action
    logout({ commit }) {
      return new Promise((resolve) => {
        commit('clearAuth')
        // goToPage(Constant.PAGE.LOGIN, true);
        // window.location.reload(); // 彻底重置状态
      })
    },
    // 添加获取公共配置的 action
    fetchPubConfig({ commit }) {
      return new Promise((resolve) => {
        Api.user.getPubConfig(({ data }) => {
          if (data.code === 0) {
            commit('setPubConfig', data.data);
          }
          resolve();
        });
      });
    }
  },
  modules: {
  }
})
export default store
