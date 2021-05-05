package com.crionuke.devstracker.core.api.revenueCat;

import com.crionuke.devstracker.core.api.revenueCat.dto.RevenueCatResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

@Component
@ConditionalOnProperty(prefix = "api.revenueCat", name = "secretKey")
public class RevenueCatApi {
    private static final Logger logger = LoggerFactory.getLogger(RevenueCatApi.class);

    private static final String BASE_URL = "https://api.revenuecat.com/";

    private final String secretKey;

    public RevenueCatApi(@Value("${api.revenueCat.secretKey}") String secretKey) {
        this.secretKey = secretKey;
        logger.info("Initialized, secretKey=\"{}\"", "..." + secretKey.substring(secretKey.length() / 2));
    }

    public Mono<RevenueCatResponse> getSubscriber(String appUserId) {
        return createWebClient().get()
                .uri(builder -> builder
                        .path("/v1/subscribers/{appUserId}")
                        .build(appUserId))
                .headers((headers) -> {
                    headers.setBearerAuth(secretKey);
                })
                .retrieve()
                .bodyToMono(RevenueCatResponse.class);
    }

    public Mono<String> getSubscriberString(String appUserId) {
        return createWebClient().get()
                .uri(builder -> builder
                        .path("/v1/subscribers/{appUserId}")
                        .build(appUserId))
                .headers((headers) -> {
                    headers.setBearerAuth(secretKey);
                })
                .retrieve()
                .bodyToMono(String.class);
    }

    private WebClient createWebClient() {
        return WebClient.builder()
                .baseUrl(BASE_URL)
                .build();
    }
}
