package com.crionuke.devstracker.core.dto;

public class Link {

    private final long id;
    private final long added;
    private final long appId;
    private final String country;

    public Link(long id, long added, long appId, String country) {
        this.id = id;
        this.added = added;
        this.appId = appId;
        this.country = country;
    }

    public long getId() {
        return id;
    }

    public long getAdded() {
        return added;
    }

    public long getAppId() {
        return appId;
    }

    public String getCountry() {
        return country;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(id=" + id + ", " +
                "added=" + added + ", " +
                "appId=" + appId + ", " +
                "country=\"" + country + "\")";
    }
}
