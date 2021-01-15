package com.crionuke.devstracker.core.dto;

import java.sql.Timestamp;

public class SearchApp {

    private final long appleId;
    private final String name;
    private final Timestamp releaseDate;

    public SearchApp(long appleId, String name, Timestamp releaseDate) {
        this.appleId = appleId;
        this.name = name;
        this.releaseDate = releaseDate;
    }

    public long getAppleId() {
        return appleId;
    }

    public String getName() {
        return name;
    }

    public Timestamp getReleaseDate() {
        return releaseDate;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(appleId=" + appleId + ", " +
                "name=" + name + ", " +
                "releaseDate=" + releaseDate + ")";
    }
}
