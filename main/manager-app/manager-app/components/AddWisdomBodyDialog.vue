<template>
  <view class="dialog-mask"  v-if="visible" @tap="handleMaskTap">
    <view class="dialog-container">
      <view class="dialog-header">
        <view class="header-icon">
          <image src="~@/static/home/equipment.png" mode="aspectFit" class="icon-img"></image>
        </view>
        <view class="header-title">添加智能体</view>
      </view>
      <view class="divider"></view>
      
      <view class="dialog-body">
        <view class="form-group">
          <view class="form-label">
            <text class="required-mark">*</text> 智能体名称：
          </view>
          <view class="input-container">
            <input 
              ref="inputRef" 
              placeholder="请输入智能体名称.." 
              v-model="wisdomBodyName"
              @confirm="confirm"
              class="input-style"
            />
          </view>
        </view>
      </view>
      
      <view class="dialog-footer">
        <view class="btn-cancel" @tap="cancel">取消</view>
        <view class="btn-confirm" @tap="confirm">确定</view>
      </view>
    </view>
  </view>
</template>

<script>
import Api from '@/apis/api';

export default {
  name: 'AddWisdomBodyDialog',
  props: {
    visible: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      wisdomBodyName: '',
      inputRef: null
    };
  },
  methods: {
    // 对话框打开时聚焦输入框
    handleOpen() {
      this.$nextTick(() => {
        this.$refs.inputRef && this.$refs.inputRef.focus();
      });
    },
    // 确定添加
    confirm() {
      const name = this.wisdomBodyName.trim();
      if (!name) {
        uni.showToast({
          title: '请输入智能体名称',
          icon: 'none'
        });
        return;
      }
      
      // 调用API添加智能体（示例，需替换为实际接口）
      Api.agent.addAgent(name, (res) => {
        uni.showToast({
          title: '添加成功',
          icon: 'success'
        });
        this.$emit('confirm', res);
        this.$emit('update:visible', false);
        this.wisdomBodyName = '';
      });
    },
    // 取消
    cancel() {
      this.$emit('update:visible', false);
	  console.log(this.visible)
      this.wisdomBodyName = '';
    },
    // 点击遮罩层关闭对话框
    handleMaskTap(e) {
      if (e.currentTarget === e.target) { // 确保点击的是遮罩层而非内容框
        this.$emit('update:visible', false);
      }
    }
  },
  mounted() {
    // 组件挂载时触发打开事件（模拟el-dialog的@open）
    this.handleOpen();
  }
};
</script>

<style scoped lang="scss">
/* 遮罩层 */
.dialog-mask {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 999;
}

/* 对话框容器 */
.dialog-container {
  width: 80%;
  max-width: 500rpx;
  background-color: #fff;
  border-radius: 30rpx;
  overflow: hidden;
  box-shadow: 0 12rpx 32rpx rgba(0, 0, 0, 0.1);
}

/* 对话框头部 */
.dialog-header {
  display: flex;
  align-items: center;
  padding: 30rpx 40rpx;
}

.header-icon {
  width: 80rpx;
  height: 80rpx;
  border-radius: 50%;
  background-color: #5778ff;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-right: 20rpx;
}

.icon-img {
  width: 36rpx;
  height: 30rpx;
}

.header-title {
  font-size: 40rpx;
  font-weight: 700;
  color: #3d4566;
}

/* 分割线 */
.divider {
  height: 2rpx;
  background-color: #e8f0ff;
}

/* 对话框主体 */
.dialog-body {
  padding: 44rpx 30rpx;
}

.form-group {
  margin-bottom: 40rpx;
}

.form-label {
  font-size: 28rpx;
  font-weight: 400;
  color: #3d4566;
  margin-bottom: 24rpx;
}

.required-mark {
  color: #ff4d4f;
  margin-right: 8rpx;
}

.input-container {
  width: 100%;
}

.input-style {
  height: 88rpx;
  background-color: #f6f8fb;
  border: 2rpx solid #e4e6ef;
  border-radius: 30rpx;
  padding: 0 30rpx;
  font-size: 28rpx;
}

/* 对话框底部按钮 */
.dialog-footer {
  display: flex;
  padding: 30rpx;
  border-top: 2rpx solid #f0f2f5;
}

.btn-cancel, .btn-confirm {
  flex: 1;
  height: 88rpx;
  border-radius: 44rpx;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 32rpx;
  font-weight: 500;
}

.btn-cancel {
  margin-right: 20rpx;
  background-color: #e6ebff;
  border: 2rpx solid #adbdff;
  color: #5778ff;
}

.btn-confirm {
  margin-left: 20rpx;
  background-color: #5778ff;
  color: #fff;
}
</style>