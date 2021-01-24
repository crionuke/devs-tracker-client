package com.crionuke.devstracker.core.dto;

import java.sql.Timestamp;

public class Link {

    private final long id;
    private final Timestamp added;
    private final long appId;
    private final String country;
    private final String title;

    public Link(long id, Timestamp added, long appId, String title, String country) {
        this.id = id;
        this.added = added;
        this.appId = appId;
        this.title = title;
        this.country = country;
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

    public String getTitle() {
        return title;
    }

    public String getCountry() {
        return country;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(id=" + id + ", " +
                "added=\"" + added + "\", " +
                "appId=" + appId + ", " +
                "title=" + title + ", " +
                "country=\"" + country + "\")";
    }
}
