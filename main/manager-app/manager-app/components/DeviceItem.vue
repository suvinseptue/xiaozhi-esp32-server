<template>
  <view class="device-item">
    <!-- 头部操作栏 -->
    <view class="item-header">
      <text class="device-name">{{ device.agentName }}</text>
      <view class="operate-icons">
        <image 
          src="~@/static/home/delete.png" 
          mode="aspectFit" 
          class="icon delete-icon"
          @tap.stop="handleDelete"
        />
        <uni-tooltip 
          :content="device.systemPrompt" 
          placement="top"
          :max-width="400"
          class="info-tooltip"
        >
          <image 
            src="~@/static/home/info.png" 
            mode="aspectFit" 
            class="icon info-icon"
          />
        </uni-tooltip>
      </view>
    </view>

    <!-- 设备信息 -->
    <view class="device-info">
      <text class="info-item">设备型号：{{ device.ttsModelName }}</text>
      <text class="info-item">音色模型：{{ device.ttsVoiceName }}</text>
    </view>

    <!-- 操作按钮组 -->
    <view class="action-buttons">
      <view class="btn" @tap="handleConfigure">配置角色</view>
<!--      <view class="btn" @tap="handleDeviceManage">设备管理({{ device.deviceCount }})</view>-->
<!--      <view -->
<!--        class="btn" -->
<!--        @tap="handleChatHistory"-->
<!--        :class="{ disabled: device.memModelId === 'Memory_nomem' }"-->
<!--      >-->
<!--        <uni-tooltip v-if="device.memModelId === 'Memory_nomem'" content="未开启记忆" placement="top">-->
<!--          <text>聊天记录</text>-->
<!--        </uni-tooltip>-->
<!--        <text v-else>聊天记录</text>-->
<!--      </view>-->
    </view>

    <!-- 最近对话时间 -->
    <view class="version-info">
      <text>最近对话：{{ formattedLastConnectedTime }}</text>
    </view>
  </view>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  device: {
    type: Object,
    required: true
  }
});

const emit = defineEmits(['delete', 'chat-history']);

// 时间格式化计算属性
const formattedLastConnectedTime = computed(() => {
  if (!props.device.lastConnectedAt) return '暂未对话';

  const lastTime = new Date(props.device.lastConnectedAt);
  const now = new Date();
  const diffMinutes = Math.floor((now - lastTime) / (1000 * 60));

  if (diffMinutes <= 1) {
    return '刚刚';
  } else if (diffMinutes < 60) {
    return `${diffMinutes}分钟前`;
  } else if (diffMinutes < 24 * 60) {
    const hours = Math.floor(diffMinutes / 60);
    const minutes = diffMinutes % 60;
    return `${hours}小时${minutes > 0 ? minutes + '分钟' : ''}前`;
  } else {
    return props.device.lastConnectedAt;
  }
});

// 事件处理方法
const handleDelete = () => {
  emit('delete', props.device.agentId);
};

const handleConfigure = () => {
  uni.navigateTo({
    url: `/pages/role-config/index?agentId=${props.device.agentId}`
  });
};

const handleDeviceManage = () => {
  uni.navigateTo({
    url: `/pages/device-management/index?agentId=${props.device.agentId}`
  });
};

const handleChatHistory = () => {
  if (props.device.memModelId === 'Memory_nomem') return;
  emit('chat-history', { 
    agentId: props.device.agentId, 
    agentName: props.device.agentName 
  });
};
</script>

<style scoped lang="scss">
.device-item {
  max-width: 684rpx; /* 原342px转换为rpx（1px=2rpx） */
  border-radius: 40rpx;
  background: #fafcfe;
  padding: 44rpx; /* 原22px转换为44rpx */
  box-sizing: border-box;
  margin: 20rpx auto;
  box-shadow: 0 4rpx 16rpx rgba(87, 120, 255, 0.05);
}

.item-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24rpx;
}

.device-name {
  font-weight: 700;
  font-size: 32rpx; /* 原18px转换为32rpx */
  color: #3d4566;
}

.operate-icons {
  display: flex;
  align-items: center;
  gap: 20rpx;
}

.icon {
  width: 36rpx; /* 原18px转换为36rpx */
  height: 36rpx;
  cursor: pointer;
}

.device-info {
  margin: 14rpx 0 20rpx; /* 原7px/10px转换为14rpx/20rpx */
}

.info-item {
  font-weight: 400;
  font-size: 24rpx; /* 原11px转换为22rpx */
  color: #3d4566;
  line-height: 1.5;
  display: block;
  margin-bottom: 8rpx;
}

.action-buttons {
  display: flex;
  gap: 20rpx;
  flex-wrap: wrap;
  margin: 24rpx 0;
}

.btn {
  font-weight: 500;
  font-size: 24rpx; /* 原12px转换为24rpx */
  color: #5778ff;
  background: #e6ebff;
  padding: 0 24rpx; /* 原12px转换为24rpx */
  height: 42rpx; /* 原21px转换为42rpx */
  line-height: 42rpx;
  border-radius: 28rpx; /* 原14px转换为28rpx */
  cursor: pointer;
  white-space: nowrap;
}

.btn.disabled {
  background: #e6e6e6;
  color: #999;
  cursor: not-allowed;
}

.version-info {
  margin-top: 30rpx; /* 原15px转换为30rpx */
  font-size: 24rpx; /* 原12px转换为24rpx */
  color: #979db1;
  font-weight: 400;
}

/* 调整uni-tooltip样式 */
::v-deep .uni-tooltip__content {
  max-width: 800rpx;
  word-break: break-word;
  font-size: 24rpx;
  padding: 16rpx 24rpx;
}
</style>