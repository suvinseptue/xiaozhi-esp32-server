// utils/query-params.js（工具函数）
/**
 * 跨平台查询参数拼接函数（替代 URLSearchParams）
 * @param {Object} params - 参数对象（如 {a: 1, b: '2'}）
 * @returns {string} 拼接后的查询字符串（如 "a=1&b=2"）
 */
export function encodeQueryParams(params) {
  if (!params || typeof params !== 'object') return '';

  return Object.entries(params)
    .filter(([_, value]) => value !== undefined && value !== null) // 过滤掉 undefined/null 值
    .map(([key, value]) => {
      // 处理数组：转换为逗号分隔（如 {arr: [1,2]} → "arr=1,2"）
      const processedValue = Array.isArray(value) ? value.join(',') : value;
      // 编码键值（处理特殊字符，如中文/空格）
      return `${encodeURIComponent(key)}=${encodeURIComponent(processedValue)}`;
    })
    .join('&');
}