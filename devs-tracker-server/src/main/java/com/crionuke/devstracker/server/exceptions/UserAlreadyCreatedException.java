package com.crionuke.devstracker.server.exceptions;

public class UserAlreadyCreatedException extends Exception {

    public UserAlreadyCreatedException(String message, Throwable cause) {
        super(message, cause);
    }
}
