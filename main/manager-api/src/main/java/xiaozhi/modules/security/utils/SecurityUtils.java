package xiaozhi.modules.security.utils;

import xiaozhi.modules.security.entity.PlatformEnum;
import xiaozhi.modules.sys.dto.SysUserDTO;

/**
 * @author : yangsuwen
 * @mailto : suvinseptue@gmail.com
 * @created : 2025/5/24, 星期六
 **/
public class SecurityUtils {
    /**
     * 校验平台
     */
    public static boolean isInnerUser(SysUserDTO userDTO) {
        return !PlatformEnum.Wechat.getCode().equals(userDTO.getPlatform());
    }
}
