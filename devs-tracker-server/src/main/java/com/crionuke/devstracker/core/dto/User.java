package com.crionuke.devstracker.core.dto;

import java.sql.Timestamp;

public class User {

    private final long id;
    private final Timestamp added;
    private final String token;

    public User(long id, Timestamp added, String token) {
        this.id = id;
        this.added = added;
        this.token = token;
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

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(id=" + id + ", " +
                "added=\"" + added + "\", " +
                "token=\"" + token + "\")";
    }
}
