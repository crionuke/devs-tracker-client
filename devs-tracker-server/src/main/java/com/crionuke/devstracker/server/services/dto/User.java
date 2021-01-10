package com.crionuke.devstracker.server.services.dto;

public class User {

    private final long id;
    private final long created;
    private final String token;

    public User(long id, long created, String token) {
        this.id = id;
        this.created = created;
        this.token = token;
    }

    public long getId() {
        return id;
    }

    public long getCreated() {
        return created;
    }

    public String getToken() {
        return token;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(id=" + id + ", " +
                "created=" + created + ", " +
                "token=\"" + token + "\")";
    }
}
