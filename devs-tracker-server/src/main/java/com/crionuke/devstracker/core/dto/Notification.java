package com.crionuke.devstracker.core.dto;

import java.sql.Timestamp;

public class Notification {

    private final long id;
    private final Timestamp added;
    private final long appId;
    private final boolean processed;
    private final Timestamp updated;

    public Notification(long id, Timestamp added, long appId, boolean processed, Timestamp updated) {
        this.id = id;
        this.added = added;
        this.appId = appId;
        this.processed = processed;
        this.updated = updated;
    }

    public long getId() {
        return id;
    }

    public Timestamp getAdded() {
        return added;
    }

    public long getAppId() {
        return appId;
    }

    public boolean isProcessed() {
        return processed;
    }

    public Timestamp getUpdated() {
        return updated;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(id=" + id + ", " +
                "added=" + added + ", " +
                "appId=" + appId + ", " +
                "processed=\"" + processed + "\", " +
                "updated=\"" + updated + "\")";
    }
}
