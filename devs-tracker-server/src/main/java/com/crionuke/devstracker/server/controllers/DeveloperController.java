package com.crionuke.devstracker.server.controllers;

import com.crionuke.devstracker.server.controllers.dto.SearchDeveloper;
import com.crionuke.devstracker.server.controllers.dto.SearchRequest;
import com.crionuke.devstracker.server.controllers.dto.SearchResponse;
import com.crionuke.devstracker.server.controllers.dto.TrackRequest;
import com.crionuke.devstracker.server.exceptions.AnonymousUserNotFoundException;
import com.crionuke.devstracker.server.exceptions.InternalServerException;
import com.crionuke.devstracker.server.services.DeveloperService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(value = "/devstracker/v1/developers")
public class DeveloperController {
    private static final Logger logger = LoggerFactory.getLogger(DeveloperController.class);

    private final DeveloperService developerService;

    public DeveloperController(DeveloperService developerService) {
        this.developerService = developerService;
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
        List<SearchDeveloper> developers = developerService.search(request.getCountries(), request.getTerm());
        return new ResponseEntity(new SearchResponse(developers.size(), developers), HttpStatus.OK);
    }

    @PostMapping(value = "/{developerAppleId}/track", consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity track(@PathVariable long developerAppleId, @RequestBody TrackRequest request) {
        if (logger.isInfoEnabled()) {
            logger.info("Track request, {}", request);
        }
        try {
            developerService.track(request.getAnonymousId(), developerAppleId);
            return new ResponseEntity(HttpStatus.OK);
        } catch (AnonymousUserNotFoundException e) {
            logger.info(e.getMessage(), e);
            return new ResponseEntity(e.getMessage(), HttpStatus.BAD_REQUEST);
        } catch (InternalServerException e) {
            logger.warn(e.getMessage(), e);
            return new ResponseEntity(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
