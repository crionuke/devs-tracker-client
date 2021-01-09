package com.crionuke.devstracker.server.exceptions;

public class DeveloperAlreadyAddedException extends Exception {

    public DeveloperAlreadyAddedException(String message, Throwable cause) {
        super(message, cause);
    }
}
