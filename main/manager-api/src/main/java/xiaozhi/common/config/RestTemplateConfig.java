package xiaozhi.common.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.List;

/**
 * RestTemplate配置
 */
@Configuration
public class RestTemplateConfig {

    @Bean
    public RestTemplate restTemplate() {
        RestTemplate restTemplate = new RestTemplate();
        // 获取默认的消息转换器列表
        List<HttpMessageConverter<?>> converters = restTemplate.getMessageConverters();

        // 找到 Jackson 转换器并修改其支持的 MediaType
        for (HttpMessageConverter<?> converter : converters) {
            if (converter instanceof MappingJackson2HttpMessageConverter) {
                MappingJackson2HttpMessageConverter jacksonConverter = (MappingJackson2HttpMessageConverter) converter;
                // 添加支持 text/plain 类型（微信 API 返回的 Content-Type 是 text/plain）
                List<MediaType> supportedMediaTypes = new ArrayList<>(jacksonConverter.getSupportedMediaTypes());
                supportedMediaTypes.add(MediaType.TEXT_PLAIN);
                jacksonConverter.setSupportedMediaTypes(supportedMediaTypes);
            }
        }

        return restTemplate;
    }
}