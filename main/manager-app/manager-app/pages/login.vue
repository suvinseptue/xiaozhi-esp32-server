<template>
	<view class="login-container">
		<button @tap="wxLogin">微信登录</button>
	</view>
</template>

<script>
	import Api from '@/apis/api';
	import {
		getUUID,
		goToPage,
		showDanger,
		showSuccess
	} from '@/utils';


	export default {
		methods: {
			async wxLogin() {
				try {
					const code = await this.getWechatCode();
					const userInfo = await this.fetchWxUserInfo(code);
					// 登录成功，存储用户信息（如 token、用户数据）
					uni.setStorageSync('userInfo', userInfo);
					uni.navigateBack(); // 跳转回上一页或首页
				} catch (err) {
					uni.showToast({
						title: '登录失败，请重试',
						icon: 'none'
					});
					console.error('微信登录错误:', err);
				}
			},

			// 获取微信 code（根据平台适配）
			getWechatCode() {
				return new Promise((resolve, reject) => {
					uni.login({
						provider: 'weixin',
						success: (res) => resolve(res.code),
						fail: reject
					});
				});
			},

			// 后端接口：用 code 换取用户信息
			async fetchWxUserInfo(code) {
				const param = {
					code: code
				}
				Api.wechat.login(param, ({
					data
				}) => {
					if (res.code !== 200) throw new Error(res.msg);
					return res.data; // 返回用户信息（如昵称、头像、openid 等）
				})
			}
		}
	};
</script>