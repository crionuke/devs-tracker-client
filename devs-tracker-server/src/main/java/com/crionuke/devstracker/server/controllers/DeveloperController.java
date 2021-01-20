package com.crionuke.devstracker.server.controllers;

import com.crionuke.devstracker.core.dto.DeveloperApp;
import com.crionuke.devstracker.core.dto.SearchDeveloper;
import com.crionuke.devstracker.core.dto.User;
import com.crionuke.devstracker.core.exceptions.InternalServerException;
import com.crionuke.devstracker.server.controllers.dto.DeveloperAppsResponse;
import com.crionuke.devstracker.server.controllers.dto.ErrorResponse;
import com.crionuke.devstracker.server.controllers.dto.SearchRequest;
import com.crionuke.devstracker.server.controllers.dto.SearchResponse;
import com.crionuke.devstracker.server.exceptions.ForbiddenRequestException;
import com.crionuke.devstracker.server.services.DeveloperService;
import com.crionuke.devstracker.server.services.UserService;
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

    @PostMapping(value = "/search", consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<SearchResponse> search(@RequestHeader HttpHeaders headers,
                                                 @RequestBody SearchRequest request) {
        if (logger.isInfoEnabled()) {
            logger.info("Search developer, {}", request);
        }
        try {
            User user = userService.authenticate(headers);
            List<SearchDeveloper> searchDevelopers = developerService.search(request.getCountries(), request.getTerm());
            return new ResponseEntity(new SearchResponse(searchDevelopers.size(), searchDevelopers), HttpStatus.OK);
        } catch (ForbiddenRequestException e) {
            logger.info(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(e.getMessage()), HttpStatus.FORBIDDEN);
        } catch (InternalServerException e) {
            logger.warn(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(e.getMessage()), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping(value = "{developerAppleId}/apps")
    public ResponseEntity getApps(@RequestHeader HttpHeaders headers, @PathVariable long developerAppleId) {
        if (logger.isInfoEnabled()) {
            logger.info("Get developer's apps, developerAppleId={}", developerAppleId);
        }
        try {
            User user = userService.authenticate(headers);
            List<DeveloperApp> developerApps = developerService.getDeveloperApps(developerAppleId);
            return new ResponseEntity(
                    new DeveloperAppsResponse(developerApps.size(), developerApps), HttpStatus.OK);
        } catch (ForbiddenRequestException e) {
            logger.info(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(e.getMessage()), HttpStatus.FORBIDDEN);
        } catch (InternalServerException e) {
            logger.warn(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(e.getMessage()), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
