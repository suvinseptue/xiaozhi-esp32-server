<template>
  <view class="contact-page">
    <!-- 联系方式卡片 -->
    <view class="contact-card">
      <!-- 手机号 -->
      <view class="contact-item" @tap="copyPhone">
        <text class="label">客服电话：</text>
        <text class="value">{{ phone }}</text>
        <text class="copy-tip">点击复制</text>
      </view>

      <!-- 邮箱 -->
      <view class="contact-item" @tap="copyEmail">
        <text class="label">客服邮箱：</text>
        <text class="value">{{ email }}</text>
        <text class="copy-tip">点击复制</text>
      </view>


      <!-- 可选：工作时间 -->
      <view class="contact-item">
        <text class="label">工作时间：</text>
        <text class="value">周一至周五 9:00-24:00（法定节假日除外）</text>
      </view>
    </view>
    <view class="action-bar">
      <button class="logout-btn" @click="logout">退出登录</button>
    </view>
  </view>
</template>

<script>
import {Storage} from "../../utils/storage";
import store from "../../store";

export default {
  data() {
    return {
      phone: '178-5733-9292', // 手机号（可替换为动态数据）
      email: 'suvinseptue@gmail.com' // 邮箱（可替换为动态数据）
    };
  },
  methods: {
    /**
     * 复制手机号到剪贴板
     */
    copyPhone() {
      this.copyToClipboard(this.phone, '手机号');
    },

    /**
     * 复制邮箱到剪贴板
     */
    copyEmail() {
      this.copyToClipboard(this.email, '邮箱');
    },

    /**
     * 通用复制函数
     * @param {string} text 要复制的文本
     * @param {string} type 类型（用于提示）
     */
    copyToClipboard(text, type) {
      uni.setClipboardData({
        data: text,
        success: () => {
          uni.showToast({
            title: `${type}已复制`,
            icon: 'none',
            duration: 2000
          });
        },
        fail: () => {
          uni.showToast({
            title: `复制${type}失败`,
            icon: 'none',
            duration: 2000
          });
        }
      });
    },
    /**
     * 退出登录
     */
    logout() {
      store.dispatch("logout");
      setTimeout(() => {
        uni.switchTab({
          url: "/pages/home/index"
        });
      }, 500)
    }
  }
};
</script>

<style scoped>
.contact-page {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding: 40rpx 30rpx;
}

.contact-card {
  background: #ffffff;
  border-radius: 16rpx;
  padding: 40rpx 30rpx;
  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.05);
}

.contact-item {
  display: flex;
  align-items: center;
  padding: 24rpx 0;
  border-bottom: 1rpx solid #f0f0f0;
}

.contact-item:last-child {
  border-bottom: none;
}

.label {
  font-size: 28rpx;
  color: #666666;
  width: 180rpx;
}

.value {
  font-size: 28rpx;
  color: #333333;
  flex: 1;
  word-break: break-all; /* 邮箱过长时自动换行 */
}

.copy-tip {
  font-size: 24rpx;
  color: #999999;
}

.logout-btn {
  flex: 1;
  background: #e6ebff;
  color: #5778ff;
  border: 2rpx solid #adbdff;
  height: 80rpx;
  border-radius: 40rpx;
  font-size: 32rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* 底部操作按钮 */
.action-bar {
  margin-top: 32rpx;
  gap: 24rpx;
  display: flex;
}
</style>