package xiaozhi.modules.security.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.io.Serializable;

/**
 * 微信登录表单
 */
@Data
@Schema(description = "微信登录表单")
public class WechatLoginDTO implements Serializable {

    @Schema(description = "微信登录")
    @NotBlank(message = "{sysuser.username.require}")
    private String code;
}