<template>
  <view class="welcome">
    <!--    <HeaderBar />-->
    <!-- 步骤导航 -->
    <view class="step-bar">
      <view class="step-item" :class="{ active: currentStep === 1 }">
        <view class="step-number">1</view>
        <text>角色配置</text>
      </view>
      <view class="step-line" :class="{ active: currentStep > 1 }"></view>
      <view class="step-item" :class="{ active: currentStep === 2 }">
        <view class="step-number">2</view>
        <text>模型配置</text>
      </view>
    </view>

    <!--    <view class="operation-bar">-->
    <!--      <view class="page-title">角色配置</view>-->
    <!--    </view>-->

    <view class="main-wrapper">
      <view class="content-panel">
        <view class="content-area">
          <view class="config-card">
            <!-- 配置头部 -->
            <view class="config-header">
              <view class="header-icon">
                <image src="~@/static/home/setting-user.png" mode="aspectFit"></image>
              </view>
              <view class="header-title">{{ form.agentName }}</view>
              <!--              <view class="custom-close-btn" @tap="goToHome">×</view>-->
            </view>
            <view class="divider"></view>

            <!-- 表单内容 -->
            <uni-forms
                ref="formRef"
                :modelValue="form"
                class="uni-form"
                :rules="validationRules"
            >
              <view class="form-content">
                <view class="form-grid">
                  <!--                  &lt;!&ndash; 左列内容 &ndash;&gt;-->
                  <!--                  <view class="form-column">-->
                  <!-- 步骤1：基础信息 -->
                  <view v-if="currentStep === 1" class="step-content">
                    <!-- 助手昵称 -->
                    <uni-forms-item
                        label="助手昵称："
                        name="agentName"
                        class="form-label"
                    >
                      <uni-easyinput
                          v-model:value="form.agentName"
                          class="form-input"
                          placeholder="请输入助手昵称"
                      />
                    </uni-forms-item>

                    <!-- 角色模板 -->
                    <uni-forms-item label="角色模版：" class="form-label">
                      <view class="template-container">
                        <view
                            v-for="(template, index) in templates"
                            :key="`template-${index}`"
                            class="template-item"
                            :class="{ 'template-loading': loadingTemplate }"
                            @tap="selectTemplate(template)"
                        >
                          {{ template.agentName }}
                        </view>
                      </view>
                    </uni-forms-item>

                    <!-- 角色介绍 -->
                    <uni-forms-item label="角色介绍：" class="form-label">
                      <uni-easyinput
                          v-model:value="form.systemPrompt"
                          type="textarea"
                          :rows="12"
                          resize="none"
                          placeholder="请输入内容"
                          :maxlength="2000"
                          show-word-limit
                          class="form-textarea"
                      />
                    </uni-forms-item>

                    <!-- 语言编码（隐藏） -->
                    <view style="display: none;">
                      <uni-forms-item
                          label="语言编码："
                          name="langCode"
                          style="display: none;"
                          class="form-label"
                      >
                        <uni-easyinput
                            v-model:value="form.langCode"
                            placeholder="请输入语言编码，如：zh_CN"
                            :maxlength="10"
                            style="display: none;"
                            show-word-limit
                            class="form-input"
                        />
                      </uni-forms-item>

                      <!-- 交互语种（隐藏） -->
                      <uni-forms-item
                          label="交互语种："
                          style="display: none;"
                          name="language"
                          class="form-label"
                      >
                        <uni-easyinput
                            v-model:value="form.language"
                            placeholder="请输入交互语种，如：中文"
                            :maxlength="10"
                            show-word-limit
                            style="display: none;"
                            class="form-input"
                        />
                      </uni-forms-item>
                    </view>
                  </view>

                  <!-- 右列内容 -->
                  <!--                    <view class="form-column">-->
                  <!-- 步骤2：高级配置 -->
                  <view v-if="currentStep === 2" class="step-content">
                    <!-- 模型配置循环 -->
                    <view
                        v-for="(model, index) in models"
                        :key="`model-${index}`"
                        class="model-item"
                    >
                      <uni-forms-item :label="model.label" class="form-label">
                        <view class="model-select-wrapper">
                          <!-- 模型选择器 -->
                          <uni-data-select
                              v-model="form.model[model.key]"
                              filterable
                              placeholder="请选择"
                              class="form-select"
                              @change="handleModelChange(model.type, $event)" :localdata="modelOptions[model.type]"
                          />

                          <!-- 功能图标（根据需求保留或删除） -->
                          <view v-if="showFunctionIcons(model.type)" class="function-icons">
                            <view
                                v-for="func in currentFunctions"
                                :key="func.name"
                                class="icon-dot"
                                :style="{ backgroundColor: getFunctionColor(func.name) }"
                            >
                              {{ func.name.charAt(0) }}
                            </view>
                            <button
                                class="edit-function-btn"
                                @click="showFunctionDialog = true"
                            >
                              编辑功能
                            </button>
                          </view>
                        </view>
                      </uni-forms-item>
                    </view>
                    <!-- 角色音色 -->
                    <view class="model-item">
                      <uni-forms-item label="角色音色">
                        <view class="model-select-wrapper">
                          <uni-data-select
                              v-model="form.ttsVoiceId"
                              placeholder="请选择"
                              class="form-select"
                              :localdata="voiceOptions"
                          />
                        </view>
                      </uni-forms-item>
                    </view>


                  </view>
                  <!--                      &lt;!&ndash; 操作按钮 &ndash;&gt;-->
                  <!--                      <view class="action-bar">-->
                  <!--                        <button-->
                  <!--                            type="primary"-->
                  <!--                            class="save-btn"-->
                  <!--                            @click="saveConfig"-->
                  <!--                        >-->
                  <!--                          保存配置-->
                  <!--                        </button>-->
                  <!--                        <button-->
                  <!--                            class="reset-btn"-->
                  <!--                            @click="resetConfig"-->
                  <!--                        >-->
                  <!--                          重置-->
                  <!--                        </button>-->
                  <!--                      </view>-->
                  <!--                      <view class="hint-text">-->
                  <!--                        <image-->
                  <!--                            src="~@/static/home/red-info.png"-->
                  <!--                            mode="aspectFit"-->
                  <!--                        ></image>-->
                  <!--                        <text>保存配置后，需要重启设备，新的配置才会生效。</text>-->
                  <!--                      </view>-->
                  <!-- 底部操作按钮 -->
                </view>
              </view>
            </uni-forms>
          </view>
        </view>
      </view>
    </view>
    <view class="bottom-actions">
      <view v-if="currentStep === 1" class="action-bar">
        <button class="next-btn" @click="nextStep">下一步</button>
      </view>
      <view v-if="currentStep === 2" class="action-group">
        <view class="action-bar">
          <button class="prev-btn" @click="prevStep">上一步</button>
          <button type="primary" class="save-btn" @click="saveConfig">提交</button>
        </view>
      </view>
      <view v-if="currentStep === 2" class="hint-text">
        <image src="~@/static/home/red-info.png" mode="aspectFit"
        ></image>
        <text>保存配置后，需要重启设备，新的配置才会生效。</text>
      </view>
    </view>

    <!-- 功能编辑对话框 -->
    <FunctionDialog v-model="showFunctionDialog" :functions="currentFunctions"
                    @update-functions="handleUpdateFunctions" @dialog-closed="handleDialogClosed"/>
  </view>
</template>


<script setup>
import {
  ref,
  watch,
  computed
} from 'vue';
import {
  onShow,
  onHide,
  onLoad
} from "@dcloudio/uni-app"

// import HeaderBar from '@/components/HeaderBar.vue';
import FunctionDialog from '@/components/FunctionDialog.vue';
import Api from '@/apis/api';
import UniEasyinput from "../../uni_modules/uni-easyinput/components/uni-easyinput/uni-easyinput.vue";

// 新增步骤控制状态
const currentStep = ref(1);

// 下一步逻辑（带表单校验）
const nextStep = () => {
  // 校验基础信息必填项
  if (!form.value.agentName || !form.value.systemPrompt) {
    uni.showToast({title: '请填写必填信息', icon: 'none'});
    return;
  }
  currentStep.value = 2;
};

// 上一步逻辑
const prevStep = () => {
  currentStep.value = 1;
};


// 表单数据
const form = ref({
  agentCode: "",
  agentName: "",
  ttsVoiceId: "",
  chatHistoryConf: 0,
  systemPrompt: "",
  langCode: "",
  language: "",
  sort: "",
  model: {
    ttsModelId: "",
    vadModelId: "",
    asrModelId: "",
    llmModelId: "",
    memModelId: "",
    intentModelId: "",
  }
});

// 模型配置
const models = ref([{
  label: '语音活动检测：',
  key: 'vadModelId',
  type: 'VAD'
},
  {
    label: '语音识别：',
    key: 'asrModelId',
    type: 'ASR'
  },
  {
    label: '大语言模型：',
    key: 'llmModelId',
    type: 'LLM'
  },
  {
    label: '意图识别：',
    key: 'intentModelId',
    type: 'Intent'
  },
  {
    label: '记忆：',
    key: 'memModelId',
    type: 'Memory'
  },
  {
    label: '语音合成：',
    key: 'ttsModelId',
    type: 'TTS'
  },
]);

// 模型选项
const modelOptions = ref({});

// 角色模板
const templates = ref([]);
const loadingTemplate = ref(false);

// 音色选项
const voiceOptions = ref([]);

// 功能对话框
const showFunctionDialog = ref(false);
const currentFunctions = ref([]);
const originalFunctions = ref([]);

// 功能颜色映射
const functionColorMap = ref([
  '#FF6B6B', '#4ECDC4', '#45B7D1',
  '#96CEB4', '#FFEEAD', '#D4A5A5', '#A2836E'
]);

// 获取功能颜色
const getFunctionColor = (name) => {
  const hash = [...name].reduce((acc, char) => acc + char.charCodeAt(0), 0);
  return functionColorMap.value[hash % 7];
};

// 检查是否显示功能图标
const showFunctionIcons = (type) => {
  return false; // 暂时不显示，与原逻辑一致
};

// 生命周期钩子
const agentId = ref()
onLoad((options) => {
  agentId.value = options.agentId;
  if (agentId) {
    fetchAgentConfig(agentId.value);
  }
  fetchModelOptions();
  fetchTemplates();
})

// 路由跳转
const goToHome = () => {
  uni.switchTab({
    url: '/pages/home/index'
  })
};

// 保存配置
const saveConfig = () => {
  const configData = {
    agentCode: form.value.agentCode,
    agentName: form.value.agentName,
    asrModelId: form.value.model.asrModelId,
    vadModelId: form.value.model.vadModelId,
    llmModelId: form.value.model.llmModelId,
    ttsModelId: form.value.model.ttsModelId,
    ttsVoiceId: form.value.ttsVoiceId,
    chatHistoryConf: form.value.chatHistoryConf,
    memModelId: form.value.model.memModelId,
    intentModelId: form.value.model.intentModelId,
    systemPrompt: form.value.systemPrompt,
    langCode: form.value.langCode,
    language: form.value.language,
    sort: form.value.sort,
    functions: currentFunctions.value
  };

  Api.agent.updateAgentConfig(agentId.value, configData, (data) => {
    if (data.data.code === 0) {
      uni.showToast({
        title: '配置保存成功',
        icon: 'success',
        duration:2000
      });
      setTimeout(()=>{
        goToHome()
      },2000)
    } else {
      uni.showToast({
        title: data.data.msg || '配置保存失败',
        icon: 'none'
      });
    }
  });
};

// 重置配置
const resetConfig = () => {
  uni.showModal({
    title: '提示',
    content: '确定要重置配置吗？',
    success: (res) => {
      if (res.confirm) {
        form.value = {
          agentCode: "",
          agentName: "",
          ttsVoiceId: "",
          chatHistoryConf: 0,
          systemPrompt: "",
          langCode: "",
          language: "",
          sort: "",
          model: {
            ttsModelId: "",
            vadModelId: "",
            asrModelId: "",
            llmModelId: "",
            memModelId: "",
            intentModelId: "",
          }
        };
        currentFunctions.value = [];
        uni.showToast({
          title: '配置已重置',
          icon: 'success'
        });
      }
    }
  });
};

// 获取角色模板
const fetchTemplates = () => {
  Api.agent.getAgentTemplate((res) => {
    console.log("after getAgentTemplate:", res)

    if (res.data.code === 0) {
      templates.value = res.data.data;
    } else {
      uni.showToast({
        title: res.data.msg || '获取模板列表失败',
        icon: 'none'
      });
    }
  });
};

// 选择模板
const selectTemplate = (template) => {
  if (loadingTemplate.value) return;
  loadingTemplate.value = true;

  try {
    applyTemplateData(template);
    uni.showToast({
      title: `「${template.agentName}」模板已应用`,
      icon: 'success'
    });
  } catch (error) {
    uni.showToast({
      title: '应用模板失败',
      icon: 'none'
    });
    console.error('应用模板失败:', error);
  } finally {
    loadingTemplate.value = false;
  }
};

// 应用模板数据
const applyTemplateData = (templateData) => {
  console.log("applyTemplateData", templateData);
  form.value = {
    ...form.value,
    agentName: templateData.agentName || form.value.agentName,
    ttsVoiceId: templateData.ttsVoiceId || form.value.ttsVoiceId,
    chatHistoryConf: templateData.chatHistoryConf || form.value.chatHistoryConf,
    systemPrompt: templateData.systemPrompt || form.value.systemPrompt,
    langCode: templateData.langCode || form.value.langCode,
    model: {
      ttsModelId: templateData.ttsModelId || form.value.model.ttsModelId,
      vadModelId: templateData.vadModelId || form.value.model.vadModelId,
      asrModelId: templateData.asrModelId || form.value.model.asrModelId,
      llmModelId: templateData.llmModelId || form.value.model.llmModelId,
      memModelId: templateData.memModelId || form.value.model.memModelId,
      intentModelId: templateData.intentModelId || form.value.model.intentModelId
    }
  };
};

// 获取设备配置
const fetchAgentConfig = (agentId) => {
  Api.agent.getDeviceConfig(agentId, (res) => {
    if (res.data.code === 0) {
      form.value = {
        ...form.value,
        ...res.data.data,
        model: {
          ttsModelId: res.data.data.ttsModelId,
          vadModelId: res.data.data.vadModelId,
          asrModelId: res.data.data.asrModelId,
          llmModelId: res.data.data.llmModelId,
          memModelId: res.data.data.memModelId,
          intentModelId: res.data.data.intentModelId
        }
      };
      currentFunctions.value = res.data.data.functions || [];
      originalFunctions.value = JSON.parse(JSON.stringify(currentFunctions.value));
    } else {
      uni.showToast({
        title: res.data.msg || '获取配置失败',
        icon: 'none'
      });
    }
  });
};

// 获取模型选项
const fetchModelOptions = () => {
  models.value.forEach(model => {
    Api.model.getModelNames(model.type, '', (res) => {
      if (res.data.code === 0) {
        modelOptions.value[model.type] = res.data.data.map(item => ({
          value: item.id,
          text: item.modelName
        }));
      } else {
        uni.showToast({
          title: res.data.msg || '获取模型选项失败',
          icon: 'none'
        });
      }
    });
  });
};

// 获取音色选项
const fetchVoiceOptions = (modelId) => {
  if (!modelId) {
    voiceOptions.value = [];
    return;
  }
  Api.model.getModelVoices(modelId, '', (res) => {
    if (res.data.code === 0 && res.data.data) {
      voiceOptions.value = res.data.data.map(voice => ({
        value: voice.id,
        text: voice.name
      }));
    } else {
      voiceOptions.value = [];
    }
  });
};

// 模型选择变化
const handleModelChange = (type, value) => {
  if (type === 'Intent' && value !== 'Intent_nointent') {
    fetchFunctionList();
  }
  if (type === 'Memory' && value === 'Memory_nomem') {
    form.value.chatHistoryConf = 0;
  }
  if (type === 'Memory' && value !== 'Memory_nomem' && (form.value.chatHistoryConf === 0 || form.value
      .chatHistoryConf === null)) {
    form.value.chatHistoryConf = 2;
  }
  console.log("handleModelChange:", type)
  // TTS模型变化时更新音色选项
  if (type === 'TTS') {
    form.value.ttsVoiceId = '';
    fetchVoiceOptions(value);
  }
};

// 获取功能列表（模拟数据）
const fetchFunctionList = () => {
  return new Promise(resolve => {
    setTimeout(() => {
      currentFunctions.value = [{
        name: '天气',
        params: {
          city: '北京'
        }
      },
        {
          name: '新闻',
          params: {
            type: '科技'
          }
        }
      ];
      originalFunctions.value = JSON.parse(JSON.stringify(currentFunctions.value));
      resolve();
    }, 500);
  });
};

// 更新功能列表
const handleUpdateFunctions = (selected) => {
  currentFunctions.value = selected;
  uni.showToast({
    title: '功能配置已保存',
    icon: 'success'
  });
};

// 对话框关闭处理
const handleDialogClosed = (saved) => {
  if (!saved) {
    currentFunctions.value = JSON.parse(JSON.stringify(originalFunctions.value));
  }
};

// 更新聊天记录配置
const updateChatHistoryConf = () => {
  if (form.value.model.memModelId === 'Memory_nomem') {
    form.value.chatHistoryConf = 0;
  }
};

// 监听TTS模型变化
watch(
    () => form.value.model.ttsModelId,
    (newVal, oldVal) => {
      if (oldVal && newVal !== oldVal) {
        form.value.ttsVoiceId = '';
        fetchVoiceOptions(newVal);
      } else {
        fetchVoiceOptions(newVal);
      }
    }, {
      immediate: true
    }
);

// 监听音色选项变化
watch(
    () => voiceOptions.value,
    (newVal) => {
      if (newVal && newVal.length > 0 && !form.value.ttsVoiceId) {
        form.value.ttsVoiceId = newVal[0].value;
      }
    }, {
      immediate: true
    }
);
</script>

<style scoped lang="scss">
.welcome {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: linear-gradient(to bottom right, #dce8ff, #e4eeff, #e6cbfd);
  background-size: cover;
}

/* 步骤导航样式 */
.step-bar {
  display: flex;
  align-items: center;
  padding: 32rpx 40rpx 0;
  background: #fff;

  .step-item {
    display: flex;
    align-items: center;
    gap: 12rpx;
    color: #979db1;
    font-size: 28rpx;

    .step-number {
      width: 40rpx;
      height: 40rpx;
      border-radius: 50%;
      border: 2rpx solid #e4e6ef;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 24rpx;
    }

    &.active {
      color: #5778ff;

      .step-number {
        background: #5778ff;
        border-color: #5778ff;
        color: white;
      }
    }
  }

  .step-line {
    flex: 1;
    height: 2rpx;
    background: #e4e6ef;
    margin: 0 20rpx;

    &.active {
      background: #5778ff;
    }
  }
}

/* 步骤内容区域 */
.step-content {
  display: flex;
  flex-direction: column;
  gap: 32rpx;
}

/* 底部操作按钮 */
.bottom-actions {
  bottom: 0;
  left: 0;
  right: 0;
  padding: 10rpx 40rpx;
  background: white;
  box-shadow: 0 -2rpx 12rpx rgba(0, 0, 0, 0.05);

  .next-btn, .save-btn, .prev-btn {
    height: 80rpx;
    border-radius: 40rpx;
    font-size: 32rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    flex: 1;
  }

  .next-btn {
    background: #5778ff;
    color: white;
  }

  .action-group {
    gap: 32rpx;

    .prev-btn {
      flex: 1;
      background: #e6ebff;
      color: #5778ff;
      border: 2rpx solid #adbdff;
    }

    .save-btn {
      flex: 1;
      background: #5778ff;
      color: white;
    }
  }
}

.operation-bar {
  display: flex;
  align-items: center;
  padding: 30rpx 40rpx;
  background-color: #fff;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.05);
}

.page-title {
  font-size: 48rpx;
  font-weight: 600;
  color: #2c3e50;
}

.main-wrapper {
  flex: 1;
  margin: 20rpx 40rpx;
  border-radius: 30rpx;
  overflow: hidden;
  box-shadow: 0 4rpx 24rpx rgba(0, 0, 0, 0.1);
  background: rgba(237, 242, 255, 0.5);
  display: flex;
  flex-direction: column;
}

.content-panel {
  flex: 1;
  border-radius: 30rpx;
  background: #fff;
  overflow: hidden;
}

.content-area {
  flex: 1;
  overflow-y: auto;
  padding: 40rpx;
  box-sizing: border-box;
}

.config-card {
  flex: 1;
}

.config-header {
  display: flex;
  align-items: center;
  gap: 26rpx;
  padding-bottom: 20rpx;
  font-weight: 700;
  font-size: 38rpx;
  color: #3d4566;
  position: relative;
}

.header-icon {
  width: 74rpx;
  height: 74rpx;
  background: #5778ff;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.header-icon image {
  width: 38rpx;
  height: 38rpx;
}

.header-title {
  flex: 1;
}

.custom-close-btn {
  position: absolute;
  top: 50%;
  right: 0;
  transform: translateY(-50%);
  width: 70rpx;
  height: 70rpx;
  border-radius: 50%;
  border: 4rpx solid #cfcfcf;
  background: none;
  font-size: 60rpx;
  font-weight: lighter;
  color: #cfcfcf;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1;
  padding: 0;
  outline: none;
  cursor: pointer;
}

.custom-close-btn:hover {
  color: #409EFF;
  border-color: #409EFF;
}

.divider {
  height: 2rpx;
  background: #e8f0ff;
  margin-bottom: 40rpx;
}

//.form-content {
//  padding-bottom: 40rpx;
//}

.form-grid {
  display: flex;
  flex-direction: column;
  gap: 40rpx;
}

/* 响应式优化：小屏幕下隐藏右列部分内容 */
@media (max-width: 768rpx) {
  .form-grid {
    grid-template-columns: 1fr;
  }
}

.form-column {
  display: flex;
  flex-direction: column;
  gap: 30rpx;
}

.form-item {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.form-label {
  font-size: 16rpx;
  color: #3d4566;
  font-weight: 400;
}

//
//.form-input,
//.form-select {
//  height: 88rpx;
//  border: 2rpx solid #e4e6ef;
//  border-radius: 16rpx;
//  padding: 0 30rpx;
//  font-size: 28rpx;
//  background-color: #f6f8fb;
//}

::v-deep .uni-easyinput__content-textarea {
  height: 480rpx;
  border: 2rpx solid #e4e6ef;
  border-radius: 16rpx;
  padding: 20rpx 30rpx;
  font-size: 28rpx;
  background-color: #f6f8fb;
  box-sizing: border-box;
}

.template-container {
  display: flex;
  gap: 12rpx; /* 模板项间距调整 */
  flex-wrap: wrap;
}

.template-item {
  background: #e6ebff;
  text-align: center;
  color: #5778ff;
  cursor: pointer;
  transition: background-color 0.3s ease;
  height: 64rpx; /* 模板项高度降低 */
  min-width: 120rpx;
  border-radius: 12rpx;
  line-height: 64rpx;
  font-size: 24rpx; /* 模板名称字体减小 */
}

.template-item:hover {
  background-color: #d0d8ff;
}

/* 底部操作按钮 */
.action-bar {
  margin-top: 32rpx;
  gap: 24rpx;
  display: flex;

  //
  //.save-btn,
  //.reset-btn {
  //  flex: 1;
  //  display: flex;
  //  align-items: center;
  //  justify-content: center;
  //  height: 72rpx; /* 按钮高度降低 */
  //  border-radius: 36rpx;
  //  font-size: 30rpx; /* 按钮文字调整 */
  //}
  //
  //.save-btn {
  //  background: #5778ff;
  //  color: white;
  //}
  //
  //.reset-btn {
  //  background: #e6ebff;
  //  color: #5778ff;
  //  border: 2rpx solid #adbdff;
  //}
}

/* 提示文字 */
.hint-text {
  margin-top: 16rpx;
  gap: 12rpx;
  font-size: 24rpx; /* 提示文字更小 */

  image {
    width: 32rpx;
    height: 32rpx; /* 提示图标缩小 */
  }
}

/* 模型选择区 */
.model-item {
  .model-select-wrapper {
    gap: 16rpx;
    display: flex;
    flex-direction: column;
  }
}

.uni-forms-item__label {
  width: 180rpx !important; /* 标签宽度固定，适配手机 */
  font-size: 24rpx;
  color: #3d4566;
  padding: 0;
}


.function-icons {
  display: flex;
  align-items: center;
  gap: 16rpx;
  margin-top: 10rpx;
}

.function-dot {
  width: 50rpx;
  height: 50rpx;
  border-radius: 50%;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-weight: bold;
  font-size: 24rpx;
  margin-right: 16rpx;
}

.edit-function-btn {
  background: #e6ebff;
  color: #5778ff;
  border: 2rpx solid #adbdff;
  border-radius: 36rpx;
  padding: 0 30rpx;
  height: 88rpx;
  line-height: 88rpx;
  font-size: 28rpx;
  transition: all 0.3s;
  display: flex;
  justify-content: center;
  align-items: center;
}

.chat-history-options {
  display: flex;
  gap: 20rpx;
  margin-top: 20rpx;
}

.radio-item {
  display: flex;
  align-items: center;
  gap: 10rpx;
  font-size: 28rpx;
  color: #606266;
}

radio {
  transform: scale(0.8);
}
</style>