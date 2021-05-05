package com.crionuke.devstracker.server.exceptions;

public class FreeTrackersLimitReachedException extends Exception {
    static public final String ID = "limit_reached";

    public FreeTrackersLimitReachedException(String message) {
        super(message);
    }
}
