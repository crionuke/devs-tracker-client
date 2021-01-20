package com.crionuke.devstracker.core.dto;

import java.sql.Timestamp;

public class DeveloperApp {

    private final long appleId;
    private final Timestamp releaseDate;
    private final String title;

    public DeveloperApp(long appleId, Timestamp releaseDate, String title) {
        this.appleId = appleId;
        this.releaseDate = releaseDate;
        this.title = title;
    }

    public long getAppleId() {
        return appleId;
    }

    public Timestamp getReleaseDate() {
        return releaseDate;
    }

    public String getTitle() {
        return title;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(appleId=" + appleId + ", " +
                "releaseDate=\"" + releaseDate + "\", " +
                "title=\"" + title + "\")";
    }
}
