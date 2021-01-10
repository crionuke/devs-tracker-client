package com.crionuke.devstracker.server.exceptions;

public class ForbiddenRequestException extends Exception {

    public ForbiddenRequestException(String message) {
        super(message);
    }
}
