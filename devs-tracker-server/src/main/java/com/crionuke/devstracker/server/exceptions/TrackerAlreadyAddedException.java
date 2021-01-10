package com.crionuke.devstracker.server.exceptions;

public class TrackerAlreadyAddedException extends Exception {

    public TrackerAlreadyAddedException(String message, Throwable cause) {
        super(message, cause);
    }
}
