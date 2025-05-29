package xiaozhi.modules.security.service;

import xiaozhi.modules.security.dto.integration.AccessTokenResponse;

/**
 * @author : yangsuwen
 * @mailto : suvinseptue@gmail.com
 * @created : 2025/5/24, 星期六
 **/
public interface WechatLoginService {

    /**
     * 微信登录核心逻辑：通过 code 获取用户信息
     */
    AccessTokenResponse login(String code);

}