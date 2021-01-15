package com.crionuke.devstracker.core.exceptions;

public class UserAlreadyAddedException extends Exception {

    public UserAlreadyAddedException(String message, Throwable cause) {
        super(message, cause);
    }
}
