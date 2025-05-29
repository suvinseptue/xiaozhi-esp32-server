// utils/auth.js（全局工具类）

import {ref} from "vue";
import store from "../store";


export function checkLogin(redirect = true) {
    const token = store.getters.getToken;
    // 未登录或无 token
    console.log("[checkLogin]token=:", token)
    if (!token) {
        console.log("[checkLogin]not login.try popup")
        store.commit("openLoginPopup");
    }
    return true;
}

// 辅助函数：将对象转为 query 参数（如 {a:1} → "a=1"）
function stringifyQuery(query) {
    return Object.keys(query)
        .map(key => `${key}=${query[key]}`)
        .join('&');
}