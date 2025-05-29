package xiaozhi.modules.security.service.impl;

import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import xiaozhi.common.config.WechatConfig;
import xiaozhi.modules.security.dto.integration.AccessTokenResponse;
import xiaozhi.modules.security.service.WechatLoginService;

/**
 * @author : yangsuwen
 * @mailto : suvinseptue@gmail.com
 * @created : 2025/5/24, 星期六
 **/
@AllArgsConstructor
@Service
public class WechatLoginServiceImpl implements WechatLoginService {

    private final WechatConfig wechatConfig;
    private final RestTemplate restTemplate;

    /**
     * 微信登录核心逻辑：通过 code 获取用户信息
     */
    @Override
    public AccessTokenResponse login(String code) {
        // 1. 使用 code 换取 access_token 和 openid
        AccessTokenResponse accessToken = getAccessToken(code);
        if (accessToken.getErrcode() != null) {
            throw new RuntimeException("微信授权失败: " + accessToken.getErrmsg() + "。code：" + code);
        }
        return accessToken;
    }

    /**
     * 调用微信 API 获取 access_token 和 openid
     */
    private AccessTokenResponse getAccessToken(String code) {
        String url = "https://api.weixin.qq.com/sns/jscode2session?" + "appid={appid}&secret={secret}&js_code={code}&grant_type=authorization_code";

        return restTemplate.getForObject(url, AccessTokenResponse.class, wechatConfig.getAppid(), wechatConfig.getSecret(), code);
    }
}