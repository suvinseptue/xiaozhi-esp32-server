<template>
  <view class="login-popup" v-show="store.state.showLoginPopup">
    <!-- 关闭按钮 -->
    <view class="close-btn" @click="closePopup">×</view>

    <!-- 头像区域 -->
    <view class="avatar-container">
      <img alt="" src="@/assets/xiaozhi-logo.png" class="avatar" mode="aspectFill"/>
    </view>

    <!-- 标题 -->
    <view class="title">一键登录</view>

    <!-- 协议勾选（使用 uni-data-checkbox） -->
    <view class="agreement-row">
      <uni-data-checkbox
          v-model="agreeProtocol"
          :localdata="[{ value: true, text: '' }]"
          shape="square"
          :color="['#ff9900']"
          class="agreement-checkbox"
      ></uni-data-checkbox>
      <text class="agreement-text">
        已阅读并同意
        <text
            class="agreement-link"
            @click="handleAgreementClick('user')"
        >《用户协议》</text>

        与
        <text
            class="agreement-link"
            @click="handleAgreementClick('privacy')"
        >《隐私协议》</text>
      </text>
    </view>

    <!-- 微信登录按钮 -->
    <button
        class="wechat-login-btn"
        @click="handleWechatLogin"
        :disabled="!agreeProtocol"
    >
      微信授权登录
    </button>
  </view>
</template>

<script setup>
import {ref} from 'vue';
import store from '/store';//需要引入store
import Api from "../apis/api";
// 弹窗状态
const showPopup = store.state.showLoginPopup;
// 协议勾选状态
const agreeProtocol = ref(false);

// 关闭弹窗
const closePopup = () => {
  store.commit("closeLoginPopup");
};
// 跳转协议页面方法
const handleAgreementClick = (type) => {
  const urlMap = {
    user: '/pages/agreement/user',    // 用户协议页面路径
    privacy: '/pages/agreement/privacy'  // 隐私协议页面路径
  };
  uni.navigateTo({
    url: urlMap[type]
  });
};
// 微信登录逻辑（示例）
const handleWechatLogin = async () => {
  if (!agreeProtocol.value) {
    uni.showToast({title: '请同意协议', icon: 'none'});
    return;
  }
  try {
    const code = await getWechatCode();
    const userRes = await fetchWxUserInfo(code);
    // 登录成功，存储用户信息（如 token、用户数据）
    console.log('微信登录 Token:', userRes);
    store.commit("setToken", userRes.token)
    closePopup();
    // 触发全局事件通知父页面刷新
    uni.$emit('loginSuccess');
    uni.showToast({title: '登录成功', icon: 'success'});
  } catch (err) {
    uni.showToast({
      title: '登录失败，请重试',
      icon: 'none'
    });
    console.error('微信登录错误:', err);
  }
};
// 后端接口：用 code 换取用户信息
const fetchWxUserInfo = (code) => {
  return new Promise((resolve, reject) => {
    Api.wechat.login({
      code: code
    }, (
        res
    ) => {
      if (res.code !== 0) throw new Error(res.msg);
      resolve(res.data); // 返回用户信息（如昵称、头像、openid 等）
    })
  })
}
// 获取微信 code（根据平台适配）
const getWechatCode = () => {
  return new Promise((resolve, reject) => {
    uni.login({
      provider: 'weixin',
      success: (res) => resolve(res.code),
      fail: reject
    });
  });
};

</script>

<style scoped lang="scss">
.login-popup {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 85%;
  max-width: 420px;
  background: #fff;
  border-radius: 16px;
  padding: 40px 24px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  text-align: center;
  z-index: 9999;

  .close-btn {
    position: absolute;
    top: 12px;
    right: 12px;
    font-size: 24px;
    color: #999;
    cursor: pointer;
  }

  .avatar-container {
    width: 80px;
    height: 80px;
    margin: 0 auto 24px;
    border-radius: 50%;
    overflow: hidden;

    .avatar {
      width: 100%;
      height: 100%;
    }
  }

  .title {
    font-size: 20px;
    color: #333;
    margin-bottom: 32px;
  }

  .agreement-row {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 32px;

    // 调整 uni-data-checkbox 的样式
    .agreement-checkbox {
      width: 20px; // 控制复选框大小
      height: 20px;
      margin-right: 8px;

      // 覆盖 uni-data-checkbox 默认样式
      ::v-deep .uni-data-checkbox {
        .uni-checkbox-input {
          width: 20px;
          height: 20px;
          border-radius: 4px; // 方形复选框
        }

        .uni-checkbox-input-checked::after {
          width: 10px; // 对勾大小
          height: 5px;
        }
      }
    }

    .agreement-text {
      font-size: 14px;
      color: #666;
      line-height: 1.4;
    }
  }

  .wechat-login-btn {
    width: 100%;
    height: 48px;
    line-height: 48px;
    background: #1aad19;
    color: #fff;
    font-size: 18px;
    border-radius: 24px;
    margin: 0;

    &:disabled {
      background: #ccc;
      cursor: not-allowed;
    }
  }
}
</style>