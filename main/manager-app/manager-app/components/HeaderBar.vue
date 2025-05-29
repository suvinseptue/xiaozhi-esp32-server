<template>
  <el-header class="header">
    <div class="header-container">
      <!-- 左侧元素 -->
      <div class="header-left" @click="goHome">
        <img loading="lazy" alt="" src="@/assets/xiaozhi-logo.png" class="logo-img" />
        <img loading="lazy" alt="" src="@/assets/xiaozhi-ai.png" class="brand-img" />
      </div>

      <!-- 中间导航菜单 -->
      <div class="header-center">
        <div class="equipment-management"
          :class="{ 'active-tab': $route.path === '/home' || $route.path === '/role-config' || $route.path === '/device-management' }"
          @click="goHome">
          <img loading="lazy" alt="" src="@/assets/header/robot.png"
            :style="{ filter: $route.path === '/home' || $route.path === '/role-config' || $route.path === '/device-management' ? 'brightness(0) invert(1)' : 'None' }" />
          智能体管理
        </div>
        <div v-if="isSuperAdmin" class="equipment-management" :class="{ 'active-tab': $route.path === '/model-config' }"
          @click="goModelConfig">
          <img loading="lazy" alt="" src="@/assets/header/model_config.png"
            :style="{ filter: $route.path === '/model-config' ? 'brightness(0) invert(1)' : 'None' }" />
          模型配置
        </div>
        <div v-if="isSuperAdmin" class="equipment-management"
          :class="{ 'active-tab': $route.path === '/user-management' }" @click="goUserManagement">
          <img loading="lazy" alt="" src="@/assets/header/user_management.png"
            :style="{ filter: $route.path === '/user-management' ? 'brightness(0) invert(1)' : 'None' }" />
          用户管理
        </div>
        <div v-if="isSuperAdmin" class="equipment-management"
          :class="{ 'active-tab': $route.path === '/ota-management' }" @click="goOtaManagement">
          <img loading="lazy" alt="" src="@/assets/header/firmware_update.png"
            :style="{ filter: $route.path === '/ota-management' ? 'brightness(0) invert(1)' : 'None' }" />
          OTA管理
        </div>
        <el-dropdown v-if="isSuperAdmin" trigger="click" class="equipment-management more-dropdown"
          :class="{ 'active-tab': $route.path === '/dict-management' || $route.path === '/params-management' }">
          <span class="el-dropdown-link">
            <img loading="lazy" alt="" src="@/assets/header/param_management.png"
              :style="{ filter: $route.path === '/dict-management' || $route.path === '/params-management' ? 'brightness(0) invert(1)' : 'None' }" />
            参数字典
            <i class="el-icon-arrow-down el-icon--right"></i>
          </span>
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item @click.native="goParamManagement">
              参数管理
            </el-dropdown-item>
            <el-dropdown-item @click.native="goDictManagement">
              字典管理
            </el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
      </div>

      <!-- 右侧元素 -->
      <div class="header-right">
        <div class="search-container" v-if="$route.path === '/home'">
          <el-input v-model="search" placeholder="输入名称搜索.." class="custom-search-input"
            @keyup.enter.native="handleSearch">
            <i slot="suffix" class="el-icon-search search-icon" @click="handleSearch"></i>
          </el-input>
        </div>
        <img loading="lazy" alt="" src="@/assets/home/avatar.png" class="avatar-img" />
        <el-dropdown trigger="click" class="user-dropdown">
          <span class="el-dropdown-link">
            {{ userInfo.username || '加载中...' }}<i class="el-icon-arrow-down el-icon--right"></i>
          </span>
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item @click.native="showChangePasswordDialog">修改密码</el-dropdown-item>
            <el-dropdown-item @click.native="handleLogout">退出登录</el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
      </div>
    </div>

    <!-- 修改密码弹窗 -->
    <ChangePasswordDialog v-model="isChangePasswordDialogVisible" />
  </el-header>
</template>

<script>
import userApi from '@/apis/module/user';
import { mapActions, mapGetters } from 'vuex';
import ChangePasswordDialog from './ChangePasswordDialog.vue'; // 引入修改密码弹窗组件


export default {
  name: 'HeaderBar',
  components: {
    ChangePasswordDialog
  },
  props: ['devices'],
  data() {
    return {
      search: '',
      userInfo: {
        username: '',
        mobile: ''
      },
      isChangePasswordDialogVisible: false,
      showDropdown: false,
      showUserDropdown: false,
      // 图标路径配置
      iconPath: '/static/header/',
      logoImg: '/static/xiaozhi-logo.png',
      brandImg: '/static/xiaozhi-ai.png',
      avatarImg: '/static/home/avatar.png'
    }
  },
  computed: {
    ...mapGetters(['getIsSuperAdmin']),
    isSuperAdmin() {
      return this.getIsSuperAdmin;
    },
    currentPath() {
      return this.$route.path;
    }
  },
  onLoad() {
    this.fetchUserInfo();
  },
  methods: {
    // 判断当前路径是否激活
    isActive(...paths) {
      return paths.some(path => this.currentPath === path);
    },
    
    // 获取激活状态的图标路径
    getActiveIcon(activePath, activePath2, activePath3, iconName) {
      if (this.isActive(activePath, activePath2, activePath3)) {
        return `${this.iconPath}${iconName}_active.png`;
      }
      return `${this.iconPath}${iconName}.png`;
    },
    
    goHome() {
      uni.navigateTo({ url: '/pages/home/index' });
    },
    goUserManagement() {
      uni.navigateTo({ url: '/pages/user-management/index' });
    },
    goModelConfig() {
      uni.navigateTo({ url: '/pages/model-config/index' });
    },
    goParamManagement() {
      uni.navigateTo({ url: '/pages/params-management/index' });
    },
    goOtaManagement() {
      uni.navigateTo({ url: '/pages/ota-management/index' });
    },
    goDictManagement() {
      uni.navigateTo({ url: '/pages/dict-management/index' });
    },
    
    fetchUserInfo() {
      userApi.getUserInfo(res => {
        this.userInfo = res.data.data;
        if (res.data.data.superAdmin !== undefined) {
          this.$store.commit('setUserInfo', res.data.data);
        }
      });
    },
    
    handleSearch() {
      const searchValue = this.search.trim();
      if (!searchValue) {
        this.$emit('search-reset');
        return;
      }
      
      try {
        const regex = new RegExp(searchValue, 'i');
        this.$emit('search', regex);
      } catch (error) {
        console.error('正则表达式创建失败:', error);
        uni.showToast({
          title: '搜索关键词格式不正确',
          icon: 'none'
        });
      }
    },
    
    showChangePasswordDialog() {
      this.isChangePasswordDialogVisible = true;
    },
    
    async handleLogout() {
      try {
        await this.logout();
        uni.showToast({
          title: '退出登录成功',
          icon: 'success'
        });
        uni.reLaunch({ url: '/pages/login/index' });
      } catch (error) {
        console.error('退出登录失败:', error);
        uni.showToast({
          title: '退出登录失败，请重试',
          icon: 'none'
        });
      }
    },
    
    ...mapActions(['logout'])
  }
}
</script>

<style scoped lang="scss">
.header {
  background: #f6fcfe66;
  border: 1rpx solid #fff;
  height: 126rpx !important;
  min-width: 900rpx;
  overflow: hidden;
  position: sticky;
  top: 0;
  z-index: 1000;
  box-shadow: 0 2rpx 4rpx rgba(0, 0, 0, 0.1);
}

.header-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 100%;
  padding: 0 20rpx;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 20rpx;
  min-width: 240rpx;
}

.logo-img {
  width: 84rpx;
  height: 84rpx;
}

.brand-img {
  height: 40rpx;
}

.header-center {
  display: flex;
  align-items: center;
  gap: 50rpx;
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
}

.header-right {
  display: flex;
  align-items: center;
  gap: 14rpx;
  min-width: 600rpx;
  justify-content: flex-end;
}

.equipment-management {
  padding: 0 18rpx;
  height: 60rpx;
  border-radius: 30rpx;
  background: #deeafe;
  display: flex;
  justify-content: center;
  font-size: 28rpx;
  font-weight: 500;
  gap: 14rpx;
  color: #3d4566;
  align-items: center;
  transition: all 0.3s ease;
  cursor: pointer;
  flex-shrink: 0;
}

.equipment-management.active-tab {
  background: #5778ff !important;
  color: #fff !important;
}

.equipment-management image {
  width: 30rpx;
  height: 26rpx;
}

.search-container {
  margin-right: 30rpx;
  min-width: 300rpx;
  flex-grow: 1;
  max-width: 440rpx;
}

.avatar-img {
  width: 42rpx;
  height: 42rpx;
  flex-shrink: 0;
  border-radius: 50%;
  border: 1rpx solid #e4e6ef;
}

.user-dropdown {
  flex-shrink: 0;
  position: relative;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8rpx;
  font-size: 28rpx;
  color: #3d4566;
  cursor: pointer;
}

.arrow-icon {
  font-size: 24rpx;
  transition: transform 0.3s ease;
}

.rotate {
  transform: rotate(180deg);
}

/* 下拉菜单样式 */
.more-dropdown {
  position: relative;
}

.dropdown-menu, .user-dropdown-menu {
  position: absolute;
  right: 0;
  top: 100%;
  background: #fff;
  border-radius: 12rpx;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.1);
  padding: 10rpx 0;
  z-index: 100;
}

.dropdown-item {
  padding: 16rpx 30rpx;
  font-size: 28rpx;
  color: #606266;
  white-space: nowrap;
  cursor: pointer;
}

.dropdown-item:hover {
  background-color: #f5f7fa;
}

/* 响应式调整 */
@media (max-width: 1200px) {
  .header-center {
    gap: 28rpx;
  }

  .equipment-management {
    width: 140rpx;
    font-size: 18rpx;
  }
}

@media (max-width: 1024px) {
  .search-container {
    margin-right: 20rpx;
    max-width: 300rpx;
  }

  .header-right {
    gap: 10rpx;
  }
}

@media (max-width: 900px) {
  .header-left {
    margin-right: auto;
  }

  .search-container {
    max-width: 300rpx;
  }
}

@media (max-width: 768px) {
  .search-container {
    max-width: 290rpx;
  }
}

@media (max-width: 600px) {
  .search-container {
    max-width: 240rpx;
    min-width: 200rpx;
  }
  
  .header-center {
    gap: 16rpx;
  }
  
  .equipment-management {
    padding: 0 12rpx;
    font-size: 24rpx;
  }
}
</style>