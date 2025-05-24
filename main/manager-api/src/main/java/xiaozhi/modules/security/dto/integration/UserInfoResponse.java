package xiaozhi.modules.security.dto.integration;

import lombok.Data;

/**
 * @author : yangsuwen
 * @mailto : suvinseptue@gmail.com
 * @created : 2025/5/24, 星期六
 **/
@Data
public class UserInfoResponse {
    private String openid;    // 用户唯一标识
    private String nickname;  // 用户昵称
    private Integer sex;      // 性别（1:男，2:女，0:未知）
    private String headImgUrl;// 用户头像 URL
    private String errcode;   // 错误码（0 表示成功）
    private String errmsg;    // 错误信息
}
