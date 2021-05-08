package com.crionuke.devstracker.actions.dto;

import java.sql.Timestamp;

public class Notification {

    private final long id;
    private final Timestamp added;
    private final long developerId;
    private final String appTitle;
    private final boolean processed;
    private final Timestamp updated;

    public Notification(long id, Timestamp added, long developerId, String appTitle, boolean processed,
                        Timestamp updated) {
        this.id = id;
        this.added = added;
        this.developerId = developerId;
        this.appTitle = appTitle;
        this.processed = processed;
        this.updated = updated;
    }

    public long getId() {
        return id;
    }

    public Timestamp getAdded() {
        return added;
    }

    public long getDeveloperId() {
        return developerId;
    }

    public String getAppTitle() {
        return appTitle;
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
                "added=\"" + added + "\", " +
                "developerId=" + developerId + ", " +
                "appTitle=\"" + appTitle + "\", " +
                "processed=\"" + processed + "\", " +
                "updated=\"" + updated + "\")";
    }
}
