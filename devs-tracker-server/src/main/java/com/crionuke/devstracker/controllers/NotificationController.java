package com.crionuke.devstracker.controllers;

import com.crionuke.devstracker.api.firebase.FirebaseApi;
import com.crionuke.devstracker.controllers.dto.ErrorResponse;
import com.crionuke.devstracker.controllers.dto.PostNotificationResponse;
import com.crionuke.devstracker.exceptions.InternalServerException;
import com.google.firebase.messaging.FirebaseMessagingException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(value = "/devstracker/v1/notifications")
public class NotificationController {
    private static final Logger logger = LoggerFactory.getLogger(NotificationController.class);

    private final FirebaseApi firebaseApi;

    public NotificationController(FirebaseApi firebaseApi) {
        this.firebaseApi = firebaseApi;
    }

    @PostMapping(value = "/{developerAppleId}/{appTitle}")
    public ResponseEntity post(@RequestHeader HttpHeaders headers, @PathVariable long developerAppleId,
                               @PathVariable String developerName, @PathVariable String appTitle) {
        try {
            firebaseApi.fire(developerAppleId, developerName, appTitle);
            return new ResponseEntity(new PostNotificationResponse(true), HttpStatus.OK);
        } catch (FirebaseMessagingException e) {
            logger.warn(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(
                    InternalServerException.ID, e.getMessage()), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
