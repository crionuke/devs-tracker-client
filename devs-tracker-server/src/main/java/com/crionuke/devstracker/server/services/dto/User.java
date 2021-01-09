package com.crionuke.devstracker.server.services.dto;

public class User {

    private final long id;
    private final long created;
    private final String anonymousId;

    public User(long id, long created, String anonymousId) {
        this.id = id;
        this.created = created;
        this.anonymousId = anonymousId;
    }

    public long getId() {
        return id;
    }

    public long getCreated() {
        return created;
    }

    public String getAnonymousId() {
        return anonymousId;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(id=" + id + ", " +
                "created=" + created + ", " +
                "anonymousId=\"" + anonymousId + "\")";
    }
}
