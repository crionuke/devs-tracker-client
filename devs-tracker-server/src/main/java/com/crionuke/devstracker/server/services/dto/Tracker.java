package com.crionuke.devstracker.server.services.dto;

public class Tracker {

    private final long id;
    private final long userId;
    private final long developerId;

    Tracker(long id, long userId, long developerId) {
        this.id = id;
        this.userId = userId;
        this.developerId = developerId;
    }

    public long getId() {
        return id;
    }

    public long getUserId() {
        return userId;
    }

    public long getDeveloperId() {
        return developerId;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(id=" + id + ", " +
                "userId=" + userId + ", " +
                "developerId=" + developerId + ")";
    }
}
