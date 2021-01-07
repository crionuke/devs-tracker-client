package com.crionuke.devstracker.server.controllers;

import com.crionuke.devstracker.server.api.AppleSearchApi;
import com.crionuke.devstracker.server.dto.SearchDevelopers;
import com.crionuke.devstracker.server.dto.SearchRequest;
import com.crionuke.devstracker.server.dto.SearchResponse;
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
    public ResponseEntity<SearchResponse> search(@RequestBody SearchRequest searchRequest) {
        if (logger.isInfoEnabled()) {
            logger.info("Search developer, {}", searchRequest);
        }

        List<SearchDevelopers> developers = appleSearchApi
                .searchDeveloper(searchRequest.getCountries(), searchRequest.getTerm())
                .flatMap(response -> Flux.fromIterable(response.getResults()))
                .map(result -> new SearchDevelopers(result.getArtistId(), result.getArtistName()))
                .distinct()
                .take(5)
                .collectList()
                .block();

        return new ResponseEntity(new SearchResponse(developers.size(), developers), HttpStatus.OK);
    }

    @PostMapping(value = "/{id}/track", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity track(@PathVariable String id) {
        return new ResponseEntity(HttpStatus.OK);
    }
}
