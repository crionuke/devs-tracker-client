package com.crionuke.devstracker.core.dto;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class DeveloperApp {

    private final long appleId;
    private final Timestamp releaseDate;
    private final List<AppLink> links;

    public DeveloperApp(long appleId, Timestamp releaseDate) {
        this.appleId = appleId;
        this.releaseDate = releaseDate;
        links = new ArrayList<>();
    }

    public long getAppleId() {
        return appleId;
    }

    public Timestamp getReleaseDate() {
        return releaseDate;
    }

    public List<AppLink> getLinks() {
        return links;
    }

    public void addLink(AppLink link) {
        links.add(link);
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(appleId=" + appleId + ", " +
                "releaseDate=\"" + releaseDate + "\")";
    }
}
