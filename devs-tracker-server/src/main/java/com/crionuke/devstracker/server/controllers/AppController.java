package com.crionuke.devstracker.server.controllers;

import com.crionuke.devstracker.core.dto.DeveloperApp;
import com.crionuke.devstracker.core.dto.User;
import com.crionuke.devstracker.core.exceptions.AppNotFoundException;
import com.crionuke.devstracker.core.exceptions.InternalServerException;
import com.crionuke.devstracker.server.controllers.dto.AppResponse;
import com.crionuke.devstracker.server.controllers.dto.ErrorResponse;
import com.crionuke.devstracker.server.exceptions.ForbiddenRequestException;
import com.crionuke.devstracker.server.services.AppService;
import com.crionuke.devstracker.server.services.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(value = "/devstracker/v1/apps")
public class AppController {
    private static final Logger logger = LoggerFactory.getLogger(AppController.class);

    private final UserService userService;
    private final AppService appService;

    public AppController(UserService userService, AppService appService) {
        this.userService = userService;
        this.appService = appService;
    }

    @GetMapping(value = "/{appAppleId}")
    public ResponseEntity getApp(@RequestHeader HttpHeaders headers, @PathVariable long appAppleId) {
        if (logger.isInfoEnabled()) {
            logger.info("Get app, appAppleId={}", appAppleId);
        }
        try {
            User user = userService.authenticate(headers);
            List<String> countries = appService.getCountries(appAppleId);
            return new ResponseEntity(new AppResponse(countries), HttpStatus.OK);
        } catch (AppNotFoundException e) {
            logger.info(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(e.getMessage()), HttpStatus.NOT_FOUND);
        } catch (ForbiddenRequestException e) {
            logger.info(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(e.getMessage()), HttpStatus.FORBIDDEN);
        } catch (InternalServerException e) {
            logger.warn(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(e.getMessage()), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
