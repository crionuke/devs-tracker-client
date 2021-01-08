package com.crionuke.devstracker.server.controllers;

import com.crionuke.devstracker.server.api.AppleSearchApi;
import com.crionuke.devstracker.server.controllers.dto.SearchDeveloper;
import com.crionuke.devstracker.server.controllers.dto.SearchRequest;
import com.crionuke.devstracker.server.controllers.dto.SearchResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;

import java.util.List;

@RestController
@RequestMapping(value = "/devstracker/v1/developers")
public class Developers {
    private static final Logger logger = LoggerFactory.getLogger(Developers.class);

    private final AppleSearchApi appleSearchApi;

    Developers(AppleSearchApi appleSearchApi) {
        this.appleSearchApi = appleSearchApi;
    }

    @GetMapping
    public ResponseEntity getTrackedDevelopers() {
        return new ResponseEntity(HttpStatus.OK);
    }

    @PostMapping(value = "/search", consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<SearchResponse> search(@RequestBody SearchRequest request) {
        if (logger.isInfoEnabled()) {
            logger.info("Search request, {}", request);
        }

        List<SearchDeveloper> developers = appleSearchApi
                .searchDeveloper(request.getCountries(), request.getTerm())
                .flatMap(response -> Flux.fromIterable(response.getResults()))
                .map(result -> new SearchDeveloper(result.getArtistId(), result.getArtistName()))
                .distinct()
                .take(8)
                .collectList()
                .block();

        SearchResponse response = new SearchResponse(request.getRquid(), developers.size(), developers);

        if (logger.isInfoEnabled()) {
            logger.info("Search response, {}", response);
        }

        return new ResponseEntity(response, HttpStatus.OK);
    }

    @PostMapping(value = "/{id}/track", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity track(@PathVariable String id) {
        return new ResponseEntity(HttpStatus.OK);
    }
}
