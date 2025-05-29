<template>
  <view class="agreement-page">
    <view class="content">
      <text class="title">隐私协议</text>
      <text class="section">
        一、数据收集\n
        1. 我们收集用户的微信头像、昵称等公开信息用于账号标识。\n
        2. 为优化服务，可能收集用户的使用记录和设备信息（如IP地址、设备型号）。\n\n

        二、数据使用\n
        1. 收集的数据仅用于提供服务、改进产品和用户沟通。\n
        2. 不会向第三方共享用户个人信息，除非获得用户明确同意或法律要求。\n\n

        三、数据安全\n
        1. 我们采取技术措施保护用户数据安全，但不保证绝对安全。\n
        2. 如发生数据泄露，将及时通知用户并依法处理。\n\n

        四、用户权利\n
        1. 用户可随时查看、更正个人信息，或申请注销账号。\n
        2. 有权拒绝提供非必要信息，但可能影响服务使用。\n\n

        五、未成年人保护\n
        1. 未成年人使用服务需获得监护人同意，我们不主动收集未成年人信息。\n\n

        六、协议更新\n
        1. 隐私政策变更时，将通过弹窗或公告形式通知用户。\n
        2. 继续使用服务即视为接受更新后的隐私政策。
      </text>
    </view>
  </view>
</template>

<script setup>
// 页面逻辑（无特殊需求可空）
</script>

<style scoped>
/* 样式与用户协议页一致 */
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
  white-space: pre-line;
}
</style>