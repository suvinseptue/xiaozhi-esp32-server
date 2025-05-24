<template>
  <view class="login-container">
    <button @tap="wxLogin">微信登录</button>
  </view>
</template>

<script>
import { getPlatform } from '@/utils/platform.js'; // 自定义平台判断工具
import http from '@/utils/http.js'; // 自定义请求工具

export default {
  methods: {
    async wxLogin() {
      const platform = getPlatform(); // 获取当前平台（mp-weixin/h5/app）
      try {
        const code = await this.getWechatCode(platform);
        const userInfo = await this.fetchWxUserInfo(code);
        // 登录成功，存储用户信息（如 token、用户数据）
        uni.setStorageSync('userInfo', userInfo);
        uni.navigateBack(); // 跳转回上一页或首页
      } catch (err) {
        uni.showToast({ title: '登录失败，请重试', icon: 'none' });
        console.error('微信登录错误:', err);
      }
    },

    // 获取微信 code（根据平台适配）
    getWechatCode(platform) {
      return new Promise((resolve, reject) => {
        switch (platform) {
          // 微信小程序
          case 'mp-weixin':
            uni.login({
              provider: 'weixin',
              success: (res) => resolve(res.code),
              fail: reject
            });
            break;

          // // H5 平台
          // case 'h5':
          //   const redirectUri = encodeURIComponent(`${window.location.origin}/pages/login/callback`);
          //   const authUrl = `https://open.weixin.qq.com/connect/oauth2/authorize?appid=${wxAppId}&redirect_uri=${redirectUri}&response_type=code&scope=snsapi_userinfo&state=uni-app#wechat_redirect`;
          //   window.location.href = authUrl; // 跳转到微信授权页
          //   break;

          // // App 平台
          // case 'app':
          //   uni.login({
          //     provider: 'weixin',
          //     success: (res) => resolve(res.code),
          //     fail: reject
          //   });
          //   break;

          default:
            reject(new Error('不支持的平台'));
        }
      });
    },

    // 后端接口：用 code 换取用户信息
    async fetchWxUserInfo(code) {
      const res = await http.post('/api/wx/login', { code });
      if (res.code !== 200) throw new Error(res.msg);
      return res.data; // 返回用户信息（如昵称、头像、openid 等）
    }
  }
};
</script>