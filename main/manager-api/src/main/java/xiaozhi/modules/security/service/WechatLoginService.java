package xiaozhi.modules.security.service;

import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import xiaozhi.common.config.WechatConfig;
import xiaozhi.modules.security.dto.integration.AccessTokenResponse;
import xiaozhi.modules.security.dto.integration.UserInfoResponse;

/**
 * @author : yangsuwen
 * @mailto : suvinseptue@gmail.com
 * @created : 2025/5/24, 星期六
 **/
public interface WechatLoginService {

    /**
     * 微信登录核心逻辑：通过 code 获取用户信息
     */
    UserInfoResponse login(String code);

}