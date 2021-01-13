package com.crionuke.devstracker.core.dto;

public class Tracker {

    private final long id;
    private final long added;
    private final long userId;
    private final long developerId;

    public Tracker(long id, long added, long userId, long developerId) {
        this.id = id;
        this.added = added;
        this.userId = userId;
        this.developerId = developerId;
    }

    public long getId() {
        return id;
    }

    public long getAdded() {
        return added;
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
                "added=" + added + ", " +
                "userId=" + userId + ", " +
                "developerId=" + developerId + ")";
    }
}
