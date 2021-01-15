package com.crionuke.devstracker.core.dto;

import java.sql.Timestamp;

public class App {

    final long id;
    final Timestamp added;
    final long appleId;
    final String title;
    final long developerId;

    public App(long id, Timestamp added, long appleId, String title, long developerId) {
        this.id = id;
        this.added = added;
        this.appleId = appleId;
        this.title = title;
        this.developerId = developerId;
    }

    public long getId() {
        return id;
    }

    public Timestamp getAdded() {
        return added;
    }

    public long getAppleId() {
        return appleId;
    }

    public String getTitle() {
        return title;
    }

    public long getDeveloperId() {
        return developerId;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(id=" + id + ", " +
                "added=" + added + ", " +
                "appleId=" + appleId + ", " +
                "title=" + title + ", " +
                "developerId=\"" + developerId + "\")";
    }
}
