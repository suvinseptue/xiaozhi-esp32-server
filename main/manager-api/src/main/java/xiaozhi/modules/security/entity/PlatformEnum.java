package xiaozhi.modules.security.entity;

import lombok.AllArgsConstructor;

/**
 * @author : yangsuwen
 * @mailto : suvinseptue@gmail.com
 * @created : 2025/5/24, 星期六
 **/
@AllArgsConstructor
public enum PlatformEnum {
    Wechat("Wechat", "微信"), INNER("INNER", "内部平台");

    private final String code;
    private final String desc;
}
