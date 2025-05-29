<template>
  <view class="welcome">
    <!-- 公共头部 -->
    <HeaderBar :devices="devices" @search="handleSearch" @search-reset="handleSearchReset"/>

    <view class="main-content">
      <!-- 首页顶部卡片 -->
      <view class="add-device">
        <view class="add-device-bg">
          <image src="/static/home/main-top-bg.png" lazy-load mode="aspectFill" class="bg-image"></image>
          <view class="hellow-text" style="margin-top: 60rpx;">你好，小智</view>
          <view class="hellow-text">
            让我们度过
            <text style="display: inline;color: #5778FF;">美好的一天！</text>
          </view>
          <view class="hi-hint">Hello, Let's have a wonderful day!</view>

          <view class="add-device-btn" @tap="showAddDialog">
            <view class="left-add">添加智能体</view>
            <view class="add-arrow"
                  style="width: 46rpx;height: 26rpx;background: #5778ff;margin-left: -20rpx;"></view>
            <view class="right-add">
              <text class="arrow-icon">→</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 设备列表容器 -->
      <view class="device-list-container">
        <!-- 骨架屏加载 -->
        <view v-if="isLoading" class="skeleton-list">
          <view v-for="i in skeletonCount" :key="'skeleton-' + i" class="skeleton-item">
            <view class="skeleton-image"></view>
            <view class="skeleton-content">
              <view class="skeleton-line"></view>
              <view class="skeleton-line-short"></view>
            </view>
          </view>
        </view>

        <!-- 实际设备列表 -->
        <view v-else class="device-list">
          <DeviceItem v-for="(item, index) in devices" :key="item.agentId" :device="item"
                      @configure="goToRoleConfig" @deviceManage="handleDeviceManage" @delete="handleDeleteAgent"
                      @chat-history="handleShowChatHistory"/>
        </view>
      </view>
    </view>

    <!--    &lt;!&ndash; 底部版本信息 &ndash;&gt;-->
    <!--    <view class="page-footer">-->
    <!--      <VersionFooter/>-->
    <!--    </view>-->
    <GlobalLoginPopup/>
    <!-- 添加智能体对话框 -->
    <AddWisdomBodyDialog v-model:visible="addDeviceDialogVisible" @confirm="handleWisdomBodyAdded"/>


    <!-- 聊天历史对话框 -->
    <!--    <ChatHistoryDialog :visible.sync="showChatHistory" :agent-id="currentAgentId" :agent-name="currentAgentName"/>-->
  </view>
</template>

<script>
import Api from '@/apis/api';
import DeviceItem from '@/components/DeviceItem.vue';
import AddWisdomBodyDialog from '@/components/AddWisdomBodyDialog.vue';
import ChatHistoryDialog from '@/components/ChatHistoryDialog.vue';
import VersionFooter from '@/components/VersionFooter.vue';
import GlobalLoginPopup from '@/components/LoginPopup.vue';
import {checkLogin} from "../../utils/auth";

export default {
  components: {
    DeviceItem,
    AddWisdomBodyDialog,
    ChatHistoryDialog,
    VersionFooter,
    GlobalLoginPopup
  },
  data() {
    return {
      addDeviceDialogVisible: false,
      devices: [],
      originalDevices: [],
      isSearching: false,
      searchRegex: null,
      isLoading: true,
      skeletonCount: 8,
      showChatHistory: false,
      currentAgentId: '',
      currentAgentName: ''
    };
  },

  beforeCreate() {
    checkLogin()
  },

  onLoad() {
    uni.$on('loginSuccess', () => this.fetchAgentList());
  },
  onShow() {
    checkLogin()
    uni.$on('loginSuccess', () => this.fetchAgentList());
    this.fetchAgentList();
  },

  methods: {
    // 显示添加对话框
    showAddDialog() {
      this.addDeviceDialogVisible = true;
    },

    // 处理添加成功回调
    handleWisdomBodyAdded() {
      this.fetchAgentList();
      this.addDeviceDialogVisible = false;
    },

    // 跳转设备管理页
    handleDeviceManage() {
      uni.navigateTo({
        url: '/pages/device-management/index'
      });
    },

    // 处理搜索
    handleSearch(regex) {
      this.isSearching = true;
      this.searchRegex = regex;
      this.applySearchFilter();
    },

    // 重置搜索
    handleSearchReset() {
      this.isSearching = false;
      this.searchRegex = null;
      this.devices = [...this.originalDevices];
    },

    // 应用搜索过滤
    applySearchFilter() {
      if (!this.isSearching || !this.searchRegex) {
        this.devices = [...this.originalDevices];
        return;
      }
      this.devices = this.originalDevices.filter(device =>
          this.searchRegex.test(device.agentName)
      );
    },

    // 获取智能体列表
    fetchAgentList() {
      this.isLoading = true;
      Api.agent.getAgentList(res => {
        if (res.data.code === 0) {
          this.originalDevices = res.data.data.map(item => ({
            ...item,
            agentId: item.id
          }));
          // 动态设置骨架屏数量（3-10个）
          this.skeletonCount = Math.min(
              Math.max(this.originalDevices.length, 3),
              10
          );
          this.handleSearchReset();
        }
        this.isLoading = false;
      }, err => {
        console.error('获取智能体列表失败:', err);
        this.isLoading = false;
      });
    },

    // 删除智能体
    handleDeleteAgent(agentId) {
      uni.showModal({
        title: '提示',
        content: '确定要删除该智能体吗？',
        success: res => {
          if (res.confirm) {
            Api.agent.deleteAgent(agentId, delRes => {
              if (delRes.data.code === 0) {
                uni.showToast({
                  title: '删除成功',
                  icon: 'success'
                });
                this.fetchAgentList();
              } else {
                uni.showToast({
                  title: delRes.data.msg || '删除失败',
                  icon: 'none'
                });
              }
            });
          }
        }
      });
    },

    // 显示聊天历史
    handleShowChatHistory({
                            agentId,
                            agentName
                          }) {
      this.currentAgentId = agentId;
      this.currentAgentName = agentName;
      this.showChatHistory = false;
    }
  }
};
</script>

<style scoped lang="scss">
.welcome {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: linear-gradient(145deg, #e6eeff, #eff0ff);
  background-size: cover;
  background-position: center;
}

.main-content {
  flex: 1;
  padding: 0 40rpx;
}

/* 顶部添加卡片 */
.add-device {
  height: 390rpx;
  border-radius: 30rpx;
  margin: 40rpx 0;
  overflow: hidden;
  background: linear-gradient(269.62deg, #e0e6fd 0%, #cce7ff 49.69%, #d3d3fe 100%);
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.05);
}

.add-device-bg {
  width: 100%;
  height: 100%;
  padding: 60rpx 50rpx;
  box-sizing: border-box;
}

.bg-image {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: -1;
  border-radius: 20rpx;
  overflow: hidden;
}

.hellow-text {
  color: #3d4566;
  font-size: 36rpx;
  font-weight: 700;
  line-height: 1.2;
  margin-bottom: 20rpx;
}

.hi-hint {
  color: #818cae;
  font-size: 24rpx;
  margin-bottom: 40rpx;
}

.add-device-btn {
  display: flex;
  align-items: center;
  cursor: pointer;
}

.left-add {
  width: 210rpx;
  height: 68rpx;
  line-height: 68rpx;
  border-radius: 34rpx;
  background: #5778ff;
  color: #fff;
  font-size: 28rpx;
  font-weight: 500;
  text-align: center;
  z-index: 1;
}

.add-arrow {
  margin-left: -20rpx;
}

.right-add {
  width: 68rpx;
  height: 68rpx;
  border-radius: 50%;
  background: #5778ff;
  margin-left: -20rpx;
  display: flex;
  justify-content: center;
  align-items: center;
}

.arrow-icon {
  color: #fff;
  font-size: 40rpx;
}

/* 设备列表容器 */
.device-list-container {
  padding: 40rpx 0;
}

.device-list {
  display: flex;
  flex-wrap: wrap;
  gap: 40rpx;
}

/* 骨架屏样式 */
.skeleton-list {
  display: flex;
  flex-wrap: wrap;
  gap: 40rpx;
}

.skeleton-item {
  width: 100%;
  min-height: 240rpx;
  background: #fff;
  border-radius: 16rpx;
  padding: 40rpx;
  box-sizing: border-box;
  position: relative;
  overflow: hidden;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.05);
}

.skeleton-image {
  width: 160rpx;
  height: 160rpx;
  background: #f0f2f5;
  border-radius: 8rpx;
  float: left;
}

.skeleton-content {
  margin-left: 180rpx;
  padding-top: 20rpx;
}

.skeleton-line {
  width: 80%;
  height: 32rpx;
  background: #f0f2f5;
  border-radius: 8rpx;
  margin-bottom: 30rpx;
}

.skeleton-line-short {
  width: 60%;
  height: 24rpx;
  background: #f0f2f5;
  border-radius: 8rpx;
}

.skeleton-item::after {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg,
      transparent,
      rgba(255, 255, 255, 0.3),
      transparent);
  animation: shimmer 1.5s infinite;
}

@keyframes shimmer {
  to {
    left: 100%;
  }
}

/* 底部版本信息 */
.page-footer {
  padding: 40rpx 0;
  text-align: center;
  color: #979db1;
  font-size: 24rpx;
}
</style>