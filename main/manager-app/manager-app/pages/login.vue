<template>
	<view class="login-container">
		<button @tap="wxLogin">微信登录</button>
	</view>
</template>

<script>
	import Api from '@/apis/api';
	import {
		Storage
	} from '@/utils/storage.js';
	import {
		getUUID,
		goToPage,
		showDanger,
		showSuccess
	} from '@/utils';


	export default {
		data() {
			return {
				isLoading: false, //登录状态锁
				redirect: '' // 登录后跳转的目标路径
			}
		},
		onLoad(query) {
			// 获取跳转过来时传递的 redirect 参数
			this.redirect = decodeURIComponent(query.redirect || '');
		},
		methods: {
			async wxLogin() {
				if (this.isLoading) return;
				this.isLoading = true;
				try {
					const code = await this.getWechatCode();
					const userInfo = await this.fetchWxUserInfo(code);
					// 登录成功，存储用户信息（如 token、用户数据）
					Storage.setSync('userInfo', userInfo, 30 * 60 * 1000)
					const token = Storage.getSync('userInfo');

					// 跳转回原页面（或首页）
					if (this.redirect) {
						uni.navigateTo({
							url: this.redirect
						});
					} else {
						uni.switchTab({
							url: '/pages/home/index'
						}); // 首页
					}
				} catch (err) {
					uni.showToast({
						title: '登录失败，请重试',
						icon: 'none'
					});
					console.error('微信登录错误:', err);
				} finally {
					this.isLoading = false;
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
			fetchWxUserInfo(code) {
				return new Promise((resolve, reject) => {
					Api.wechat.login({
						code: code
					}, (
						res
					) => {
						if (res.code !== 0) throw new Error(res.msg);
						resolve(res.data); // 返回用户信息（如昵称、头像、openid 等）
					})
				})
			}
		}
	};
</script>