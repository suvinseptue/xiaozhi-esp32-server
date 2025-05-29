<template>
  <!-- 抽屉容器（使用 uni-popup 实现右侧弹出） -->
  <uni-popup 
    v-model="dialogVisible" 
    type="right" 
    :mask="false" 
    :duration="300"
    :custom-style="{ width: '90%', maxWidth: '680rpx' }"
  >
    <!-- 自定义标题栏 -->
    <view class="custom-header">
      <view class="header-left">
        <text class="bold-title">功能管理</text>
      </view>
      <view class="custom-close-btn" @tap="closeDialog">×</view>
    </view>

    <!-- 主体内容区域 -->
    <view class="function-container">
      <!-- 未选/已选功能列（双列布局） -->
      <view class="function-columns">
        <!-- 未选功能 -->
        <view class="function-column">
          <view class="column-header">
            <text class="column-title">未选功能</text>
            <text @tap="selectAll" class="select-all-btn">全选</text>
          </view>
          <scroll-view 
            class="function-list" 
            scroll-y 
            :style="{ height: `${listHeight}rpx` }"
          >
            <view 
              v-for="func in unselected" 
              :key="func.name" 
              class="function-item"
            >
              <!-- 复选框 -->
              <uni-checkbox 
                :value="func.name" 
                v-model="selectedNames"
                @change="(e) => onCheckboxChange(func, e.mp.detail.value.includes(func.name))"
              />
              <!-- 功能标签（带颜色点） -->
              <view class="func-tag" @tap="onFunctionClick(func)">
                <view 
                  class="color-dot" 
                  :style="{ backgroundColor: getFunctionColor(func.name) }"
                ></view>
                <text>{{ func.name }}</text>
              </view>
              <!-- 提示图标 -->
              <uni-tooltip 
                :content="func.description || '暂无功能描述'" 
                placement="top"
              >
                <image 
                  src="/static/home/info.png" 
                  mode="aspectFit" 
                  class="info-icon"
                ></image>
              </uni-tooltip>
            </view>
          </scroll-view>
        </view>

        <!-- 已选功能 -->
        <view class="function-column">
          <view class="column-header">
            <text class="column-title">已选功能</text>
            <text @tap="deselectAll" class="select-all-btn">全选</text>
          </view>
          <scroll-view 
            class="function-list" 
            scroll-y 
            :style="{ height: `${listHeight}rpx` }"
          >
            <view 
              v-for="func in selectedList" 
              :key="func.name" 
              class="function-item"
            >
              <uni-checkbox 
                :value="func.name" 
                v-model="selectedNames"
                @change="(e) => onCheckboxChange(func, e.mp.detail.value.includes(func.name))"
              />
              <view class="func-tag" @tap="onFunctionClick(func)">
                <view 
                  class="color-dot" 
                  :style="{ backgroundColor: getFunctionColor(func.name) }"
                ></view>
                <text>{{ func.name }}</text>
              </view>
            </view>
          </scroll-view>
        </view>
      </view>

      <!-- 参数配置区 -->
      <view class="params-section">
        <text v-if="currentFunction" class="section-title">参数配置 - {{ currentFunction.name }}</text>
        <view v-if="currentFunction" class="params-form">
          <view 
            v-for="(val, key) in currentFunction.params" 
            :key="key" 
            class="param-item"
          >
            <text class="param-label">{{ key }}</text>
            <uni-easyinput 
              v-model="currentFunction.params[key]" 
              type="text"
              class="param-input"
              @input="(e) => onParamChange(currentFunction, key, e.mp.detail.value)"
            />
          </view>
        </view>
        <view v-else class="empty-tip">请选择已配置的功能进行参数设置</view>
      </view>
    </view>

    <!-- 底部操作栏 -->
    <view class="footer-actions">
      <uni-button type="default" @tap="closeDialog">取消</uni-button>
      <uni-button type="primary" @tap="saveConfig">保存配置</uni-button>
    </view>
  </uni-popup>
</template>

<script setup>
import { ref, computed, watch } from 'vue';

// 获取设备信息（计算滚动区域高度）
const { screenHeight } = uni.getSystemInfoSync();
const listHeight = ref(screenHeight * 2 - 400); // 转换为rpx（1rpx=0.5px）

// 组件参数（父组件控制显隐 + 已选功能列表）
const props = defineProps({
  visible: Boolean, // 控制抽屉显隐
  selectedFunctions: { // 父组件传入的已选功能列表
    type: Array,
    default: () => []
  }
});

// 事件（通知父组件状态变化）
const emit = defineEmits([
  'update:visible', // 显隐状态变化
  'save', // 保存配置
  'close' // 关闭抽屉
]);

// 响应式数据
const dialogVisible = ref(props.visible);
const selectedNames = ref(props.selectedFunctions.map(f => f.name)); // 已选功能名称
const currentFunction = ref(null); // 当前选中功能（用于参数配置）
const tempParams = ref({}); // 临时修改的参数（未保存时暂存）

// 模拟功能列表（实际项目中可通过接口获取）
const allFunctions = ref([
  {name: '天气', params: {city: '北京'}, description: '查看指定城市的天气情况'},
  {name: '新闻', params: {type: '科技'}, description: '获取最新科技类新闻资讯'},
  {name: '工具', params: {category: '常用'}, description: '提供常用工具集合'},
  {name: '退出', params: {}, description: '退出当前系统'},
  {name: '音乐', params: {genre: '流行'}, description: '播放流行音乐'},
  {name: '翻译', params: {from: '中文', to: '英文'}, description: '提供中英文互译功能'},
  {name: '计算', params: {precision: '2'}, description: '提供精确计算功能'},
  {name: '日历', params: {view: '月'}, description: '查看月历视图'}
]);

// 颜色映射（根据功能名称生成不同颜色）
const colorList = ['#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEEAD', '#D4A5A5', '#A2836E'];
const getFunctionColor = (name) => {
  const hash = [...name].reduce((sum, char) => sum + char.charCodeAt(0), 0);
  return colorList[hash % colorList.length];
};

// 计算属性：已选/未选功能列表
const selectedList = computed(() => 
  allFunctions.value.filter(f => selectedNames.value.includes(f.name))
);
const unselected = computed(() => 
  allFunctions.value.filter(f => !selectedNames.value.includes(f.name))
);

// 监听父组件传入的 visible 变化
watch(() => props.visible, (newVal) => {
  dialogVisible.value = newVal;
  if (newVal) {
    // 重置临时参数（避免上次修改残留）
    tempParams.value = {};
    // 同步已选功能名称
    selectedNames.value = props.selectedFunctions.map(f => f.name);
    // 默认选中第一个已选功能
    currentFunction.value = selectedList.value[0] ? JSON.parse(JSON.stringify(selectedList.value[0])) : null;
  }
});

// 监听 dialogVisible 变化并通知父组件
watch(dialogVisible, (newVal) => {
  emit('update:visible', newVal);
});

// 复选框选择/取消选择功能
const onCheckboxChange = (func, isChecked) => {
  if (isChecked) {
    if (!selectedNames.value.includes(func.name)) {
      selectedNames.value.push(func.name);
    }
  } else {
    selectedNames.value = selectedNames.value.filter(name => name !== func.name);
  }
  // 更新当前选中功能（若已选列表为空则置空）
  currentFunction.value = selectedList.value[0] ? JSON.parse(JSON.stringify(selectedList.value[0])) : null;
};

// 点击功能项（查看/编辑参数）
const onFunctionClick = (func) => {
  if (selectedNames.value.includes(func.name)) {
    // 从临时参数或原始数据中获取当前功能的参数
    currentFunction.value = tempParams.value[func.name] || JSON.parse(JSON.stringify(func));
  }
};

// 参数修改时暂存修改
const onParamChange = (func, key, value) => {
  if (!tempParams.value[func.name]) {
    tempParams.value[func.name] = JSON.parse(JSON.stringify(func));
  }
  tempParams.value[func.name].params[key] = value;
};

// 全选未选功能
const selectAll = () => {
  selectedNames.value = allFunctions.value.map(f => f.name);
  currentFunction.value = selectedList.value[0] ? JSON.parse(JSON.stringify(selectedList.value[0])) : null;
};

// 全不选已选功能
const deselectAll = () => {
  selectedNames.value = [];
  currentFunction.value = null;
};

// 关闭抽屉（重置状态）
const closeDialog = () => {
  dialogVisible.value = false;
  tempParams.value = {};
  emit('close');
};

// 保存配置（通知父组件）
const saveConfig = () => {
  // 合并临时修改和原始数据
  const finalSelected = selectedList.value.map(func => {
    const modified = tempParams.value[func.name];
    return modified || func;
  });
  // 通知父组件保存
  emit('save', finalSelected);
  // 关闭抽屉并提示
  dialogVisible.value = false;
  uni.showToast({ title: '配置保存成功', icon: 'success' });
};
</script>

<style scoped lang="scss">
/* 整体布局 */
.function-container {
  padding: 30rpx;
  height: calc(100vh - 160rpx); /* 留出标题和底部操作栏空间 */
}

/* 标题栏 */
.custom-header {
  padding: 40rpx 30rpx;
  border-bottom: 2rpx solid #f0f0f0;
  display: flex;
  justify-content: space-between;
  align-items: center;

  .bold-title {
    font-size: 36rpx;
    font-weight: bold;
    color: #333;
  }

  .custom-close-btn {
    width: 60rpx;
    height: 60rpx;
    border: 2rpx solid #ddd;
    border-radius: 50%;
    color: #999;
    font-size: 50rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s;
  }
}

/* 功能列（未选/已选） */
.function-columns {
  display: flex;
  gap: 30rpx;
  margin-bottom: 40rpx;

  .function-column {
    flex: 1;
    max-width: 50%;

    .column-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20rpx;

      .column-title {
        font-size: 30rpx;
        color: #666;
        font-weight: 500;
      }

      .select-all-btn {
        font-size: 28rpx;
        color: #5778ff;
      }
    }

    .function-list {
      border-radius: 16rpx;
      background: #f8f9fd;
      padding: 20rpx;
    }

    .function-item {
      display: flex;
      align-items: center;
      gap: 20rpx;
      padding: 16rpx;
      border-radius: 12rpx;
      transition: background 0.2s;

      &:hover {
        background: #e6ebff;
      }
    }
  }
}

/* 功能标签（带颜色点） */
.func-tag {
  display: flex;
  align-items: center;
  flex-grow: 1;

  .color-dot {
    width: 16rpx;
    height: 16rpx;
    border-radius: 50%;
    margin-right: 16rpx;
  }

  text {
    font-size: 28rpx;
    color: #333;
  }
}

/* 提示图标 */
.info-icon {
  width: 32rpx;
  height: 32rpx;
  opacity: 0.7;
}

/* 参数配置区 */
.params-section {
  background: #f8f9fd;
  border-radius: 16rpx;
  padding: 20rpx;

  .section-title {
    font-size: 30rpx;
    color: #333;
    font-weight: 500;
    margin-bottom: 20rpx;
  }

  .params-form {
    display: flex;
    flex-direction: column;
    gap: 20rpx;
  }

  .param-item {
    display: flex;
    flex-direction: column;
    gap: 12rpx;

    .param-label {
      font-size: 28rpx;
      color: #666;
    }

    .param-input {
      height: 68rpx;
      padding: 0 20rpx;
      border: 2rpx solid #e4e6ef;
      border-radius: 12rpx;
      font-size: 28rpx;
      background: #fff;
    }
  }
}

/* 空提示 */
.empty-tip {
  padding: 40rpx;
  font-size: 28rpx;
  color: #999;
  text-align: center;
}

/* 底部操作栏 */
.footer-actions {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 30rpx;
  border-top: 2rpx solid #f0f0f0;
  background: #fff;
  display: flex;
  gap: 30rpx;

  uni-button {
    flex: 1;
    height: 88rpx;
    font-size: 32rpx;
    border-radius: 44rpx;
  }

  .uni-button-primary {
    background: #5778ff;
  }
}

/* 复选框样式覆盖 */
::v-deep .uni-checkbox-input {
  width: 36rpx;
  height: 36rpx;
}

::v-deep .uni-checkbox-input-checked {
  background: #5778ff;
  border-color: #5778ff;
}
</style>
