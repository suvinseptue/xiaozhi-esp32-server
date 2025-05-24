package xiaozhi.modules.security.dto.integration;

import lombok.Data;

/**
 * @author : yangsuwen
 * @mailto : suvinseptue@gmail.com
 * @created : 2025/5/24, 星期六
 **/
@Data
public class AccessTokenResponse {
    private String accessToken;  // 接口调用凭证
    private String openid;        // 用户唯一标识
    private Integer expiresIn;   // 凭证有效期（秒）
    private String errcode;       // 错误码（0 表示成功）
    private String errmsg;        // 错误信息
}
