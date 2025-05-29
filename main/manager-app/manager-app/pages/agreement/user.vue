<template>
  <view class="agreement-page">
    <!-- 导航栏自动显示返回按钮（UniApp默认） -->
    <view class="content">
      <text class="title">用户协议</text>
      <text class="section">
        一、服务条款\n
        1. 本服务由开发者提供，旨在为用户提供便捷的功能体验。\n
        2. 用户需年满18周岁或在监护人陪同下使用本服务。\n
        3. 开发者有权根据实际情况调整服务内容，无需提前通知用户。\n\n

        二、账号注册与使用\n
        1. 用户需通过微信授权方式注册账号，保证信息真实有效。\n
        2. 账号仅限本人使用，不得转让、出租或借用他人。\n
        3. 因用户保管不当导致账号泄露，责任由用户自行承担。\n\n

        三、用户行为规范\n
        1. 禁止利用本服务从事违法、违规或侵权行为。\n
        2. 不得干扰服务正常运行，不得擅自修改服务功能。\n
        3. 开发者有权对违规账号采取限制措施。\n\n

        四、责任限制\n
        1. 开发者对服务的可用性、准确性不做绝对保证。\n
        2. 因不可抗力或第三方原因导致的服务中断，开发者不承担责任。\n\n

        五、协议变更\n
        1. 开发者可随时更新本协议，更新后继续使用即视为同意新条款。\n
        2. 用户如不同意变更，可停止使用本服务。
      </text>
    </view>
  </view>
</template>

<script setup>
// 页面逻辑（无特殊需求可空）
</script>

<style scoped>
.agreement-page {
  padding: 24px;
  background: #f8f8f8;
  min-height: 100vh;
}

.title {
  font-size: 20px;
  font-weight: bold;
  color: #333;
  margin-bottom: 20px;
}

.section {
  font-size: 14px;
  color: #666;
  line-height: 1.6;
  white-space: pre-line; /* 保留换行符 */
}
</style>