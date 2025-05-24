package xiaozhi.common.config;

import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * @author : yangsuwen
 * @mailto : suvinseptue@gmail.com
 * @created : 2025/5/24, 星期六
 **/
@Component
@Data
public class WechatConfig {
    @Value("${wechat.appid}")
    private String appid;
    @Value("${wechat.secret}")
    private String secret;
}
