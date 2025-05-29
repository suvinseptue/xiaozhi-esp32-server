<template>
  <view class="page-container">
    <!-- 顶部导航 -->
    <view class="header-bar">
      <view class="back-btn" @click="goToHome">
        <image src="/static/icons/back.png" mode="aspectFit"></image>
      </view>
      <text class="page-title">角色配置</text>
    </view>

    <!-- 主内容区 -->
    <scroll-view class="main-content" scroll-y>
      <view class="config-card">
        <!-- 卡片头部 -->
        <view class="card-header">
          <view class="header-icon">
            <image src="/static/icons/setting-user.png" mode="aspectFit"></image>
          </view>
          <text class="card-title">{{ form.agentName }}</text>
        </view>
        <view class="divider"></view>

        <!-- 表单内容 -->
        <view class="form-content">
          <!-- 基础信息 -->
          <view class="form-section">
            <text class="section-title">基础信息</text>
            <uni-forms ref="roleForm" :model="form">
              <uni-forms-item label="助手昵称" required>
                <uni-easyinput 
                  v-model="form.agentName" 
                  placeholder="请输入助手昵称"
                  class="form-input"
                />
              </uni-forms-item>
              
              <uni-forms-item label="角色介绍" required>
                <uni-easyinput 
                  type="textarea" 
                  v-model="form.systemPrompt" 
                  placeholder="请输入角色介绍"
                  rows="6"
                  maxlength="2000"
                  show-word-limit
                  class="form-textarea"
                />
              </uni-forms-item>
            </uni-forms>
          </view>

          <!-- 模型配置 -->
          <view class="form-section">
            <text class="section-title">模型配置</text>
            <view class="model-group">
              <view v-for="model in models" :key="model.key" class="model-item">
                <text class="model-label">{{ model.label }}</text>
                <uni-data-select 
                  v-model="form.model[model.key]"
                  :localdata="modelOptions[model.type]"
                  placeholder="请选择"
                  class="model-select"
                  @change="handleModelChange(model.type, $event)"
                />
              </view>
            </view>
          </view>

          <!-- 语音配置 -->
          <view class="form-section">
            <text class="section-title">语音配置</text>
            <uni-forms-item label="角色音色">
              <uni-data-select 
                v-model="form.ttsVoiceId"
                :localdata="voiceOptions"
                placeholder="请选择音色"
                class="model-select"
              />
            </uni-forms-item>
          </view>

          <!-- 功能配置 -->
          <view class="form-section" v-if="showFunctionIcons">
            <text class="section-title">功能配置</text>
            <view class="function-group">
              <view v-for="func in currentFunctions" :key="func.name" class="function-item">
                <view class="function-dot" :style="{ backgroundColor: getFunctionColor(func.name) }">
                  {{ func.name.substr(0,1) }}
                </view>
                <text class="function-name">{{ func.name }}</text>
              </view>
              <uni-button 
                type="primary" 
                size="mini" 
                class="edit-func-btn" 
                @click="showFunctionDialog = true"
              >
                编辑功能
              </uni-button>
            </view>
          </view>

          <!-- 操作按钮 -->
          <view class="action-buttons">
            <uni-button type="default" @click="resetConfig">重置</uni-button>
            <uni-button type="primary" @click="saveConfig">保存配置</uni-button>
          </view>

          <!-- 提示信息 -->
          <view class="hint-text">
            <image src="/static/icons/red-info.png" mode="aspectFit"></image>
            <text>保存配置后，需要重启设备，新的配置才会生效。</text>
          </view>
        </view>
      </view>
    </scroll-view>

    <!-- 功能编辑弹窗 -->
    <function-dialog 
      v-model:visible="showFunctionDialog"
      :functions="currentFunctions"
      :all-functions="allFunctions"
      @update-functions="handleUpdateFunctions"
    />
  </view>
</template>

<script setup>
import { ref, reactive, watch } from 'vue';
import { uniRequest } from '@/utils/request';  // 假设的uni-app请求封装
import FunctionDialog from '@/components/FunctionDialog.vue';

// 页面数据
const form = reactive({
  agentCode: '',
  agentName: '',
  ttsVoiceId: '',
  chatHistoryConf: 0,
  systemPrompt: '',
  langCode: '',
  language: '',
  sort: '',
  model: {
    ttsModelId: '',
    vadModelId: '',
    asrModelId: '',
    llmModelId: '',
    memModelId: '',
    intentModelId: ''
  }
});

// 常量配置
const models = ref([
  { label: '语音活动检测(VAD)', key: 'vadModelId', type: 'VAD' },
  { label: '语音识别(ASR)', key: 'asrModelId', type: 'ASR' },
  { label: '大语言模型(LLM)', key: 'llmModelId', type: 'LLM' },
  { label: '意图识别(Intent)', key: 'intentModelId', type: 'Intent' },
  { label: '记忆(Memory)', key: 'memModelId', type: 'Memory' },
  { label: '语音合成(TTS)', key: 'ttsModelId', type: 'TTS' }
]);

const modelOptions = ref({});
const voiceOptions = ref([]);
const showFunctionDialog = ref(false);
const currentFunctions = ref([]);
const allFunctions = ref([
  { name: '天气', params: {} },
  { name: '新闻', params: {} },
  { name: '工具', params: {} },
  { name: '退出', params: {} }
]);
const functionColorMap = ['#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEEAD', '#D4A5A5', '#A2836E'];

// 生命周期
onLoad((options) => {
  const agentId = options.agentId;
  if (agentId) {
    fetchAgentConfig(agentId);
    fetchFunctionList();
  }
  fetchModelOptions();
  fetchTemplates();
});

// 方法定义
const goToHome = () => {
  uni.navigateBack();  // 小程序返回上一页
};

const saveConfig = () => {
  const configData = { ...form, functions: currentFunctions.value };
  uniRequest({
    url: `/agent/update/${form.agentCode}`,
    method: 'POST',
    data: configData,
    success: (res) => {
      if (res.code === 0) {
        uni.showToast({ title: '保存成功', icon: 'success' });
      } else {
        uni.showToast({ title: res.msg || '保存失败', icon: 'none' });
      }
    }
  });
};

const resetConfig = () => {
  uni.showModal({
    title: '提示',
    content: '确定要重置配置吗？',
    success: (res) => {
      if (res.confirm) {
        // 重置表单数据
        Object.assign(form, {
          agentName: '',
          ttsVoiceId: '',
          systemPrompt: '',
          model: { ...form.model }
        });
        currentFunctions.value = [];
        uni.showToast({ title: '已重置', icon: 'success' });
      }
    }
  });
};

const fetchAgentConfig = (agentId) => {
  uniRequest({
    url: `/agent/config/${agentId}`,
    success: (res) => {
      if (res.code === 0) {
        Object.assign(form, res.data);
        currentFunctions.value = res.data.functions || [];
      }
    }
  });
};

const fetchModelOptions = () => {
  models.value.forEach(model => {
    uniRequest({
      url: `/model/options/${model.type}`,
      success: (res) => {
        modelOptions.value[model.type] = res.data.map(item => ({
          value: item.id,
          text: item.modelName
        }));
      }
    });
  });
};

const getFunctionColor = (name) => {
  const hash = [...name].reduce((acc, char) => acc + char.charCodeAt(0), 0);
  return functionColorMap[hash % 7];
};

const handleUpdateFunctions = (selected) => {
  currentFunctions.value = selected;
  uni.showToast({ title: '功能配置保存成功', icon: 'success' });
};

// 监听模型变化
watch(() => form.model.ttsModelId, (newVal) => {
  if (newVal) {
    uniRequest({
      url: `/model/voices/${newVal}`,
      success: (res) => {
        voiceOptions.value = res.data.map(voice => ({
          value: voice.id,
          text: voice.name
        }));
      }
    });
  }
}, { immediate: true });
</script>

<style scoped lang="scss">
.page-container {
  height: 100vh;
  background: #f5f7fa;
}

/* 顶部导航 */
.header-bar {
  height: 100rpx;
  padding: 0 30rpx;
  display: flex;
  align-items: center;
  background: #fff;
  border-bottom: 1rpx solid #e8f0ff;

  .back-btn {
    width: 40rpx;
    height: 40rpx;
    margin-right: 30rpx;

    image {
      width: 100%;
      height: 100%;
    }
  }

  .page-title {
    font-size: 36rpx;
    color: #2c3e50;
    font-weight: 600;
  }
}

/* 主内容区 */
.main-content {
  padding: 30rpx;
}

.config-card {
  background: #fff;
  border-radius: 20rpx;
  padding: 40rpx 30rpx;
  box-shadow: 0 4rpx 20rpx rgba(87, 120, 255, 0.08);
}

.card-header {
  display: flex;
  align-items: center;
  gap: 20rpx;
  margin-bottom: 30rpx;

  .header-icon {
    width: 60rpx;
    height: 60rpx;
    background: #5778ff;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;

    image {
      width: 32rpx;
      height: 32rpx;
    }
  }

  .card-title {
    font-size: 32rpx;
    color: #3d4566;
    font-weight: 600;
  }
}

.divider {
  height: 2rpx;
  background: #e8f0ff;
  margin: 30rpx 0;
}

/* 表单部分 */
.form-section {
  margin-bottom: 40rpx;

  .section-title {
    font-size: 30rpx;
    color: #3d4566;
    font-weight: 600;
    margin-bottom: 20rpx;
  }
}

.form-input {
  height: 80rpx;
  border: 2rpx solid #e6ebff;
  border-radius: 16rpx;
  padding: 0 20rpx;
  font-size: 28rpx;
}

.form-textarea {
  min-height: 240rpx;
  border: 2rpx solid #e6ebff;
  border-radius: 16rpx;
  padding: 20rpx;
  font-size: 28rpx;
}

.model-group {
  display: flex;
  flex-direction: column;
  gap: 24rpx;

  .model-item {
    display: flex;
    flex-direction: column;
    gap: 12rpx;

    .model-label {
      font-size: 28rpx;
      color: #666;
    }

    .model-select {
      .uni-data-select {
        border: 2rpx solid #e6ebff;
        border-radius: 16rpx;
        height: 80rpx;
        font-size: 28rpx;
      }
    }
  }
}

.function-group {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 20rpx;
  margin: 20rpx 0;

  .function-item {
    display: flex;
    align-items: center;
    gap: 12rpx;

    .function-dot {
      width: 40rpx;
      height: 40rpx;
      border-radius: 50%;
      color: #fff;
      font-size: 24rpx;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .function-name {
      font-size: 28rpx;
      color: #333;
    }
  }

  .edit-func-btn {
    height: 60rpx;
    line-height: 60rpx;
    padding: 0 30rpx;
    border-radius: 30rpx;
    font-size: 28rpx;
  }
}

.action-buttons {
  display: flex;
  gap: 30rpx;
  margin: 40rpx 0;

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

.hint-text {
  display: flex;
  align-items: center;
  gap: 12rpx;
  color: #979db1;
  font-size: 24rpx;
  margin-top: 20rpx;

  image {
    width: 32rpx;
    height: 32rpx;
  }
}
</style>
