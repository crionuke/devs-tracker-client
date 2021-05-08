package com.crionuke.devstracker.actions.dto;

import java.sql.Timestamp;

public class NotificationForUpdate {

    private final long id;
    private final Timestamp added;
    private final Timestamp updated;

    private final App app;
    private final Developer developer;

    public NotificationForUpdate(long id, Timestamp added, Timestamp updated, App app, Developer developer) {
        this.id = id;
        this.added = added;
        this.updated = updated;
        this.app = app;
        this.developer = developer;
    }

    public long getId() {
        return id;
    }

    public Timestamp getAdded() {
        return added;
    }

    public Timestamp getUpdated() {
        return updated;
    }

    public App getApp() {
        return app;
    }

    public Developer getDeveloper() {
        return developer;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(id=" + id + ", " +
                "added=" + added + ", " +
                "updated=\"" + updated + "\", " +
                "app=" + app + ", " +
                "developer=" + developer + ")";
    }
}
