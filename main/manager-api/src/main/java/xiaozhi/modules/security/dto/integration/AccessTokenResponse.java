package xiaozhi.modules.security.dto.integration;

import lombok.Data;

/**
 * @author : yangsuwen
 * @mailto : suvinseptue@gmail.com
 * @created : 2025/5/24, 星期六
 **/
@Data
public class AccessTokenResponse {
    private String session_key;        //会话密钥
    private String unionid;        //用户在开放平台的唯一标识符，若当前小程序已绑定到微信开放平台帐号下会返回，详见 UnionID 机制说明。
    private String errmsg;        //错误信息，请求失败时返回
    private String openid;        //用户唯一标识
    private String errcode;        //错误码，请求失败时返回
}
