package com.crionuke.devstracker.core.dto;

import java.sql.Timestamp;

public class Tracker {

    private final long id;
    private final Timestamp added;
    private final long userId;
    private final long developerId;

    public Tracker(long id, Timestamp added, long userId, long developerId) {
        this.id = id;
        this.added = added;
        this.userId = userId;
        this.developerId = developerId;
    }

    public long getId() {
        return id;
    }

    public Timestamp getAdded() {
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
