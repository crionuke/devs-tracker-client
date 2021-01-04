package com.crionuke.devstracker.server.api;

import com.crionuke.devstracker.server.api.dto.AppleSearchResponse;
import com.crionuke.devstracker.server.controllers.Developers;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

import java.io.IOException;

@Component
public class AppleSearchApi {
    private static final Logger logger = LoggerFactory.getLogger(Developers.class);

    private static final String BASE_URL = "https://itunes.apple.com";
    private static final int SEARCH_LIMIT = 10;

    public AppleSearchResponse searchDeveloper(String name, String country) throws IOException {
        WebClient webClient = createWebClient();

        String response = webClient.get()
                .uri(builder -> builder
                        .path("/search")
                        .queryParam("term", name)
                        .queryParam("country", country)
                        .queryParam("media", "software")
                        .queryParam("entity", "software")
                        .queryParam("attribute", "softwareDeveloper")
                        .queryParam("limit", SEARCH_LIMIT)
                        .build()
                )
                .retrieve()
                .bodyToMono(String.class)
                .block();

        if (logger.isTraceEnabled()) {
            logger.trace(response);
        }

        return new ObjectMapper().readValue(response, AppleSearchResponse.class);
    }

    private WebClient createWebClient() {
        return WebClient.builder()
                .baseUrl(BASE_URL)
                .build();
    }
}
