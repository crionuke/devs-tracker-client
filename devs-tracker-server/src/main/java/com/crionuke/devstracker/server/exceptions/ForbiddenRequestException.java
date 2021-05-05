package com.crionuke.devstracker.server.exceptions;

public class ForbiddenRequestException extends Exception {
    static public final String ID = "forbidden";

    public ForbiddenRequestException(String message) {
        super(message);
    }
}
