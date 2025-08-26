package com.example.javaservice.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.Contact;
import org.springframework.boot.info.BuildProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI springShopOpenAPI(BuildProperties buildProperties) {
        return new OpenAPI()
                .info(
                        new Info()
                                .title("Slack Service")
                                .description("API Documentation for the Slack Service")
                                .version(buildProperties.getVersion()));
    }
}
