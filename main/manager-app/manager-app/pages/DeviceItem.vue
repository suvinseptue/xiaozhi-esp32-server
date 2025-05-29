<template>
  <view class="device-item" @tap.stop>
    <view class="device-cover">
      <image 
        :src="device.cover || '~@/static/default-cover.png'" 
        mode="aspectFill"
      />
    </view>
    <view class="device-info">
      <view class="device-name">{{device.agentName}}</view>
      <view class="device-desc">{{device.description}}</view>
    </view>
    <view class="device-actions">
      <text 
        class="action-btn" 
        @tap="handleConfigure"
      >配置</text>
      <text 
        class="action-btn" 
        @tap="handleManage"
      >管理</text>
    </view>
  </view>
</template>

<script>
export default {
  props: {
    device: {
      type: Object,
      required: true
    }
  },
  methods: {
    handleConfigure() {
      this.$emit('configure');
    },
    handleManage() {
      this.$emit('deviceManage');
    }
  }
};
</script>

<style scoped lang="scss">
.device-item {
  width: 100%;
  background: #fff;
  border-radius: 16rpx;
  padding: 40rpx;
  display: flex;
  align-items: center;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.05);
}

.device-cover {
  width: 120rpx;
  height: 120rpx;
  border-radius: 12rpx;
  overflow: hidden;
  margin-right: 40rpx;
}

.device-cover image {
  width: 100%;
  height: 100%;
}

.device-info {
  flex: 1;
}

.device-name {
  font-size: 32rpx;
  color: #333;
  font-weight: 600;
  margin-bottom: 12rpx;
}

.device-desc {
  font-size: 24rpx;
  color: #666;
}

.device-actions {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.action-btn {
  font-size: 24rpx;
  color: #5778ff;
  padding: 8rpx 24rpx;
  border: 1rpx solid #e0e6ff;
  border-radius: 30rpx;
  white-space: nowrap;
}
</style>