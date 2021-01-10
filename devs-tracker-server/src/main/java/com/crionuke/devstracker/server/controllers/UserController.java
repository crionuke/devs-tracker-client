package com.crionuke.devstracker.server.controllers;

import com.crionuke.devstracker.server.controllers.dto.ErrorResponse;
import com.crionuke.devstracker.server.exceptions.UserAlreadyCreatedException;
import com.crionuke.devstracker.server.exceptions.InternalServerException;
import com.crionuke.devstracker.server.services.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/devstracker/v1/users")
public class UserController {
    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping(value = "/{token}", consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity createUser(@PathVariable String token) {
        if (logger.isInfoEnabled()) {
            logger.info("Post user, token={}", token);
        }
        try {
            userService.createUser(token);
            return new ResponseEntity(HttpStatus.CREATED);
        } catch (UserAlreadyCreatedException e) {
            logger.info(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(e.getMessage()), HttpStatus.BAD_REQUEST);
        } catch (InternalServerException e) {
            logger.warn(e.getMessage(), e);
            return new ResponseEntity(new ErrorResponse(e.getMessage()), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
