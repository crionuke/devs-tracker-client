package com.crionuke.devstracker.server.exceptions;

public class UserAlreadyAddedException extends Exception {

    public UserAlreadyAddedException(String message, Throwable cause) {
        super(message, cause);
    }
}
