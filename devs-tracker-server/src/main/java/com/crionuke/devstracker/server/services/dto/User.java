package com.crionuke.devstracker.server.services.dto;

public class User {

    private final long id;
    private final long added;
    private final String token;

    public User(long id, long added, String token) {
        this.id = id;
        this.added = added;
        this.token = token;
    }

    public long getId() {
        return id;
    }

    public long getAdded() {
        return added;
    }

    public String getToken() {
        return token;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(id=" + id + ", " +
                "added=" + added + ", " +
                "token=\"" + token + "\")";
    }
}
