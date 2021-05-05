package com.crionuke.devstracker.server.controllers;

import com.crionuke.devstracker.core.dto.TrackedDeveloper;
import com.crionuke.devstracker.core.dto.Tracker;
import com.crionuke.devstracker.core.dto.User;
import com.crionuke.devstracker.core.exceptions.*;
import com.crionuke.devstracker.server.controllers.dto.ErrorResponse;
import com.crionuke.devstracker.server.controllers.dto.TrackedResponse;
import com.crionuke.devstracker.server.exceptions.DeveloperNotCachedException;
import com.crionuke.devstracker.server.exceptions.ForbiddenRequestException;
import com.crionuke.devstracker.server.exceptions.FreeTrackersLimitReachedException;
import com.crionuke.devstracker.server.services.TrackerService;
import com.crionuke.devstracker.server.services.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
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
        try {
            User user = userService.authenticate(headers);
            if (logger.isInfoEnabled()) {
                logger.info("Get trackers, user={}", user);
            }
            List<TrackedDeveloper> trackedDevelopers = trackerService.getDevelopers(user);
            logger.debug("List has {} tracked developers, {}", trackedDevelopers.size(), trackedDevelopers);
            return new ResponseEntity(
                    new TrackedResponse(trackedDevelopers.size(), trackedDevelopers), HttpStatus.OK);
        } catch (ForbiddenRequestException e) {
            logger.info(e.getMessage());
            return new ResponseEntity(new ErrorResponse(
                    ForbiddenRequestException.ID, e.getMessage()), HttpStatus.FORBIDDEN);
        } catch (InternalServerException e) {
            logger.warn(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(
                    InternalServerException.ID, e.getMessage()), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping(value = "/{developerAppleId}")
    public ResponseEntity post(@RequestHeader HttpHeaders headers, @PathVariable long developerAppleId) {
        try {
            User user = userService.authenticate(headers);
            if (logger.isInfoEnabled()) {
                logger.info("Post tracker, developerAppleId={}, user={}", developerAppleId, user);
            }
            trackerService.trackDeveloper(user, developerAppleId);
            return new ResponseEntity(HttpStatus.CREATED);
        } catch (ForbiddenRequestException e) {
            logger.info(e.getMessage());
            return new ResponseEntity(new ErrorResponse(
                    ForbiddenRequestException.ID, e.getMessage()), HttpStatus.FORBIDDEN);
        } catch (DeveloperNotCachedException e) {
            logger.info(e.getMessage());
            return new ResponseEntity(new ErrorResponse(
                    DeveloperNotCachedException.ID, e.getMessage()), HttpStatus.BAD_REQUEST);
        } catch (FreeTrackersLimitReachedException e) {
            logger.info(e.getMessage());
            return new ResponseEntity(new ErrorResponse(
                    FreeTrackersLimitReachedException.ID, e.getMessage()), HttpStatus.CONFLICT);
        } catch (TrackerAlreadyAddedException e) {
            logger.info(e.getMessage());
            return new ResponseEntity(new ErrorResponse(
                    TrackerAlreadyAddedException.ID, e.getMessage()), HttpStatus.CONFLICT);
        } catch (InternalServerException e) {
            logger.warn(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(
                    TrackerAlreadyAddedException.ID, e.getMessage()), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @DeleteMapping(value = "/{developerAppleId}")
    public ResponseEntity delete(@RequestHeader HttpHeaders headers, @PathVariable long developerAppleId) {
        try {
            User user = userService.authenticate(headers);
            if (logger.isInfoEnabled()) {
                logger.info("Delete tracker, developerAppleId={}, user={}", developerAppleId, user);
            }
            trackerService.deleteTracker(user, developerAppleId);
            return new ResponseEntity(HttpStatus.OK);
        } catch (ForbiddenRequestException e) {
            logger.info(e.getMessage());
            return new ResponseEntity(new ErrorResponse(
                    ForbiddenRequestException.ID, e.getMessage()), HttpStatus.FORBIDDEN);
        } catch (DeveloperNotFoundException e) {
            logger.info(e.getMessage());
            return new ResponseEntity(new ErrorResponse(
                    DeveloperNotFoundException.ID, e.getMessage()), HttpStatus.NO_CONTENT);
        } catch (TrackerNotFoundException e) {
            logger.info(e.getMessage());
            return new ResponseEntity(new ErrorResponse(
                    TrackerNotFoundException.ID, e.getMessage()), HttpStatus.NO_CONTENT);
        } catch (InternalServerException e) {
            logger.warn(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(
                    InternalServerException.ID, e.getMessage()), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
