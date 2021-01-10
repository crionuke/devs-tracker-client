package com.crionuke.devstracker.server.exceptions;

public class UnauthorizedRequestException extends Exception {

    public UnauthorizedRequestException(String message) {
        super(message);
    }
}
