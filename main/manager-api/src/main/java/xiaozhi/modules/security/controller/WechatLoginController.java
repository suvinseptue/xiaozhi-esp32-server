package xiaozhi.modules.security.controller;

import cn.hutool.http.useragent.Platform;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.bind.annotation.*;
import xiaozhi.common.exception.RenException;
import xiaozhi.common.page.TokenDTO;
import xiaozhi.common.utils.Result;
import xiaozhi.modules.security.dto.WechatLoginDTO;
import xiaozhi.modules.security.dto.integration.AccessTokenResponse;
import xiaozhi.modules.security.entity.PlatformEnum;
import xiaozhi.modules.security.service.SysUserTokenService;
import xiaozhi.modules.security.service.WechatLoginService;
import xiaozhi.modules.security.utils.FunnyNicknameGenerator;
import xiaozhi.modules.sys.dto.SysUserDTO;
import xiaozhi.modules.sys.service.SysUserService;

/**
 * 微信登录控制层
 */
@AllArgsConstructor
@RestController
@RequestMapping("/wechat")
@Tag(name = "微信登录管理")
public class WechatLoginController {
    private final SysUserService sysUserService;
    private final SysUserTokenService sysUserTokenService;
    private final WechatLoginService wechatLoginService;

    @PostMapping("/login")
    @Operation(summary = "登录")
    public Result<TokenDTO> login(@RequestBody WechatLoginDTO loginDTO) {
        if (StringUtils.isBlank(loginDTO.getCode())) {
            throw new RenException("code 不能为空");
        }
        AccessTokenResponse response = wechatLoginService.login(loginDTO.getCode());
        // 按照用户名获取用户
        SysUserDTO userDTO = sysUserService.getByWechatId(response.getOpenid());
        if (userDTO == null) {
            //创建用户
            userDTO = new SysUserDTO();
            userDTO.setUsername(FunnyNicknameGenerator.generateFunnyNickname());
            userDTO.setPlatformId(response.getOpenid());
            userDTO.setPlatform(PlatformEnum.Wechat.getCode());
            sysUserService.save(userDTO);
            // 重新获取
            userDTO = sysUserService.getByWechatId(response.getOpenid());
        }
        return sysUserTokenService.createToken(userDTO.getId());

    }
}
