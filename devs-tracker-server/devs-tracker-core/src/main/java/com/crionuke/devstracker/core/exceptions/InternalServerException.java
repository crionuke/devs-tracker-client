package com.crionuke.devstracker.core.exceptions;

public class InternalServerException extends Exception {

    public InternalServerException(String message) {
        super(message);
    }

    public InternalServerException(String message, Throwable cause) {
        super(message, cause);
    }
}
