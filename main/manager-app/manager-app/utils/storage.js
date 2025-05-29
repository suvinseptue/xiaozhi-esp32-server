// utils/storage.js
export const Storage = {
    /**
     * 存储带有效期的数据（同步）
     * @param {string} key 存储键
     * @param {any} value 存储值
     * @param {number} expires 有效期（毫秒，如 30*60*1000 表示 30 分钟）
     */
    setSync(key, value, expires) {
        const data = {
            value, expires: Date.now() + expires // 当前时间 + 有效期
        };
        uni.setStorageSync(key, data);
    },

    /**
     * 读取带有效期的数据（同步）
     * @returns {any} 未过期返回数据，过期返回 null
     */
    getSync(key) {
        const data = uni.getStorageSync(key);
        if (!data) return null;

        const now = Date.now();
        if (now < data.expires) {
            return data.value; // 未过期
        } else {
            uni.removeStorageSync(key); // 过期则删除
            return null;
        }
    },

    /**
     * 清除所有过期数据（同步）
     */
    clearExpiredSync() {
        const keys = uni.getStorageInfoSync().keys;
        keys.forEach(key => {
            const data = uni.getStorageSync(key);
            if (data?.expires && Date.now() > data.expires) {
                uni.removeStorageSync(key);
            }
        });
    }, /**
     * 清楚指定数据
     * @param {string} key 存储健
     */
    removeSync(key) {
        console.log("[debug]removeSync",key)
        uni.removeStorageSync(key);
    }
};