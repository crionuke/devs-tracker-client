package com.crionuke.devstracker.core.exceptions;

public class TrackerNotFoundException extends Exception {
    static public final String ID = "not_found";

    public TrackerNotFoundException(String message) {
        super(message);
    }
}
