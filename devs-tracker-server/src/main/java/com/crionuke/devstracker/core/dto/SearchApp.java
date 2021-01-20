package com.crionuke.devstracker.core.dto;

import java.sql.Timestamp;

public class SearchApp {

    private final long appleId;
    private final String title;
    private final Timestamp releaseDate;

    public SearchApp(long appleId, String title, Timestamp releaseDate) {
        this.appleId = appleId;
        this.title = title;
        this.releaseDate = releaseDate;
    }

    public long getAppleId() {
        return appleId;
    }

    public String getTitle() {
        return title;
    }

    public Timestamp getReleaseDate() {
        return releaseDate;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(appleId=" + appleId + ", " +
                "title=\"" + title + "\", " +
                "releaseDate=\"" + releaseDate + "\")";
    }
}
