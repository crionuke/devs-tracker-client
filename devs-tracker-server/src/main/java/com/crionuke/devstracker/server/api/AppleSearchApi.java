package com.crionuke.devstracker.server.api;

import com.crionuke.devstracker.server.api.dto.AppleSearchResponse;
import com.crionuke.devstracker.server.controllers.Developers;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.Exceptions;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.io.IOException;
import java.util.List;

@Component
public class AppleSearchApi {
    private static final Logger logger = LoggerFactory.getLogger(Developers.class);

    private static final String BASE_URL = "https://itunes.apple.com";
    private static final int SEARCH_LIMIT = 10;

    public Flux<AppleSearchResponse> searchDeveloper(List<String> countries, String term) {
        return Flux.fromIterable(countries)
                .flatMap(country -> searchDeveloperForCountry(term, country));
    }

    private Mono<AppleSearchResponse> searchDeveloperForCountry(String term, String country) {
        return createWebClient().get()
                .uri(builder -> builder
                        .path("/search")
                        .queryParam("term", term)
                        .queryParam("country", country)
                        .queryParam("limit", SEARCH_LIMIT)
                        .queryParam("media", "software")
                        .queryParam("entity", "software")
                        .queryParam("attribute", "softwareDeveloper")
                        .build())
                .retrieve()
                .bodyToMono(String.class)
                .map(body -> {
                    try {
                        return new ObjectMapper().readValue(body, AppleSearchResponse.class);
                    } catch (IOException e) {
                        throw Exceptions.propagate(e);
                    }
                })
                .onErrorResume(t -> {
                    logger.warn("Search API request failed, term={}, country={}, error={}",
                            term, country, t.getMessage());
                    return Mono.just(new AppleSearchResponse());
                });
    }

    private WebClient createWebClient() {
        return WebClient.builder()
                .baseUrl(BASE_URL)
                .build();
    }
}
