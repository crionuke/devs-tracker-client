package com.crionuke.devstracker.server.controllers;

import com.crionuke.devstracker.server.controllers.dto.ErrorResponse;
import com.crionuke.devstracker.server.controllers.dto.SearchRequest;
import com.crionuke.devstracker.server.controllers.dto.SearchResponse;
import com.crionuke.devstracker.server.controllers.dto.TrackedDevelopersResponse;
import com.crionuke.devstracker.server.exceptions.*;
import com.crionuke.devstracker.server.services.DeveloperService;
import com.crionuke.devstracker.server.services.TrackerService;
import com.crionuke.devstracker.server.services.UserService;
import com.crionuke.devstracker.server.services.dto.SearchDeveloper;
import com.crionuke.devstracker.server.services.dto.TrackedDeveloper;
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
@RequestMapping(value = "/devstracker/v1/trackers")
public class TrackerController {
    private static final Logger logger = LoggerFactory.getLogger(TrackerController.class);

    private final UserService userService;
    private final TrackerService trackerService;

    public TrackerController(UserService userService, TrackerService trackerService) {
        this.userService = userService;
        this.trackerService = trackerService;
    }

    @GetMapping
    public ResponseEntity get(@RequestHeader HttpHeaders headers) {
        if (logger.isInfoEnabled()) {
            logger.info("Get trackers");
        }
        try {
            User user = userService.selectUser(headers);
            List<TrackedDeveloper> trackedDevelopers = trackerService.getDevelopers(user);
            return new ResponseEntity(
                    new TrackedDevelopersResponse(trackedDevelopers.size(), trackedDevelopers), HttpStatus.OK);
        } catch (ForbiddenRequestException e) {
            logger.info(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(e.getMessage()), HttpStatus.FORBIDDEN);
        } catch (InternalServerException e) {
            logger.warn(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(e.getMessage()), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping(value = "/{developerAppleId}", consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity post(@RequestHeader HttpHeaders headers, @PathVariable long developerAppleId) {
        if (logger.isInfoEnabled()) {
            logger.info("Post tracker, developerAppleId={}", developerAppleId);
        }
        try {
            User user = userService.selectUser(headers);
            trackerService.trackDeveloper(user, developerAppleId);
            return new ResponseEntity(HttpStatus.CREATED);
        } catch (ForbiddenRequestException e) {
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

    @DeleteMapping(value = "/{developerAppleId}", consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity delete(@RequestHeader HttpHeaders headers, @PathVariable long developerAppleId) {
        if (logger.isInfoEnabled()) {
            logger.info("Delete tracker, developerAppleId={}", developerAppleId);
        }
        try {
            User user = userService.selectUser(headers);
            trackerService.deleteTracker(user, developerAppleId);
            return new ResponseEntity(HttpStatus.OK);
        } catch (ForbiddenRequestException e) {
            logger.info(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(e.getMessage()), HttpStatus.FORBIDDEN);
        } catch (DeveloperNotFoundException e) {
            logger.info(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(e.getMessage()), HttpStatus.NO_CONTENT);
        } catch (TrackerNotFoundException e) {
            logger.info(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(e.getMessage()), HttpStatus.NO_CONTENT);
        } catch (InternalServerException e) {
            logger.warn(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(e.getMessage()), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}