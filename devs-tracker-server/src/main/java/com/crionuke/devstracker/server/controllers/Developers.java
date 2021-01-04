package com.crionuke.devstracker.server.controllers;

import com.crionuke.devstracker.server.api.AppleSearchApi;
import com.crionuke.devstracker.server.api.dto.AppleSearchResponse;
import com.crionuke.devstracker.server.dto.SearchDevelopers;
import com.crionuke.devstracker.server.dto.SearchRequest;
import com.crionuke.devstracker.server.dto.SearchResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

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
            logger.info("SearchRequest request, {}", searchRequest);
        }
        try {
            AppleSearchResponse appleSearchResponse =
                    appleSearchApi.searchDeveloper(searchRequest.getName(), "us");
            List<SearchDevelopers> developers = appleSearchResponse.getResults().stream()
                    .map(r -> new SearchDevelopers(r.getArtistId(), r.getArtistName()))
                    .distinct()
                    .collect(Collectors.toList());
            return new ResponseEntity(new SearchResponse(developers.size(), developers), HttpStatus.OK);
        } catch (IOException e) {
            logger.warn(e.getMessage(), e);
            return new ResponseEntity(new SearchResponse(), HttpStatus.NOT_FOUND);
        }
    }

    @PostMapping(value = "/{id}/track", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity track(@PathVariable String id) {
        return new ResponseEntity(HttpStatus.OK);
    }
}
