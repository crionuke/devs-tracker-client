package com.crionuke.devstracker.server.controllers;

import com.crionuke.devstracker.server.controllers.dto.*;
import com.crionuke.devstracker.server.exceptions.*;
import com.crionuke.devstracker.server.services.DeveloperService;
import com.crionuke.devstracker.server.services.UserService;
import com.crionuke.devstracker.server.services.dto.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(value = "/devstracker/v1/developers")
public class DeveloperController {
    private static final Logger logger = LoggerFactory.getLogger(DeveloperController.class);

    private final UserService userService;
    private final DeveloperService developerService;

    public DeveloperController(UserService userService, DeveloperService developerService) {
        this.userService = userService;
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
    public ResponseEntity track(@RequestHeader HttpHeaders headers, @PathVariable long developerAppleId) {
        if (logger.isInfoEnabled()) {
            logger.info("Track request, developerAppleId={}", developerAppleId);
        }
        try {
            User user = userService.selectUser(headers);
            developerService.track(user, developerAppleId);
            return new ResponseEntity(HttpStatus.OK);
        } catch (UnauthorizedRequestException e) {
            logger.info(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(e.getMessage()), HttpStatus.FORBIDDEN);
        } catch (DeveloperNotCachedException e) {
            logger.info(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(e.getMessage()), HttpStatus.BAD_REQUEST);
        } catch (TrackerAlreadyAddedException e) {
            logger.info(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(e.getMessage()), HttpStatus.BAD_REQUEST);
        } catch (InternalServerException e) {
            logger.warn(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(e.getMessage()), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
