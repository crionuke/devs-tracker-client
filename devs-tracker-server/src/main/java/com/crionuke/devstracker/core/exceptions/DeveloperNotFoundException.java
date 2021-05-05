package com.crionuke.devstracker.core.exceptions;

public class DeveloperNotFoundException extends Exception {
    static public final String ID = "developer_not_found";

    public DeveloperNotFoundException(String message) {
        super(message);
    }
}
