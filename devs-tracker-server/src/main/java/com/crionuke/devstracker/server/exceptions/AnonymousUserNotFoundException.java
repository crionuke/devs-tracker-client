package com.crionuke.devstracker.server.exceptions;

public class AnonymousUserNotFoundException extends Exception {

    public AnonymousUserNotFoundException(String message) {
        super(message);
    }
}
