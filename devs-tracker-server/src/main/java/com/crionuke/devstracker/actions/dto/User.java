package com.crionuke.devstracker.actions.dto;

import java.sql.Timestamp;

public class User {

    private final long id;
    private final Timestamp added;
    private final String token;
    private final String device;

    public User(long id, Timestamp added, String token, String device) {
        this.id = id;
        this.added = added;
        this.token = token;
        this.device = device;
    }

    public long getId() {
        return id;
    }

    public Timestamp getAdded() {
        return added;
    }

    public String getToken() {
        return token;
    }

    public String getDevice() {
        return device;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(id=" + id + ", " +
                "added=\"" + added + "\", " +
                "token=\"" + "..." + token.substring(token.length() / 2) + "\", " +
                "device=\"" + "..." + device.substring(device.length() / 2) + "\")";
    }
}
