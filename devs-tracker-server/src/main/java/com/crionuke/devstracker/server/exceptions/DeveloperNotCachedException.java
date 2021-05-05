package com.crionuke.devstracker.server.exceptions;

public class DeveloperNotCachedException extends Exception {
    static public final String ID = "bad_request";

    public DeveloperNotCachedException(String message) {
        super(message);
    }
}
