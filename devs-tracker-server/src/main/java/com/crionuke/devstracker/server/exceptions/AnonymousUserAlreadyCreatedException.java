package com.crionuke.devstracker.server.exceptions;

public class AnonymousUserAlreadyCreatedException extends Exception {

    public AnonymousUserAlreadyCreatedException(String message, Throwable cause) {
        super(message, cause);
    }
}
