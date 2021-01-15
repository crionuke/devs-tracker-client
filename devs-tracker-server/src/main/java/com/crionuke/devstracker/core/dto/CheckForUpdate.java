package com.crionuke.devstracker.core.dto;

import java.sql.Timestamp;

public class CheckForUpdate {

    private final long id;
    private final long developerAppleId;
    private final String developerName;
    private final String country;
    private final int priority;
    private final Timestamp lastCheck;

    public CheckForUpdate(long id, long developerAppleId, String developerName,
                   String country, int priority, Timestamp lastCheck) {
        this.id = id;
        this.developerAppleId = developerAppleId;
        this.developerName = developerName;
        this.country = country;
        this.priority = priority;
        this.lastCheck = lastCheck;
    }

    public long getId() {
        return id;
    }

    public long getDeveloperAppleId() {
        return developerAppleId;
    }

    public String getDeveloperName() {
        return developerName;
    }

    public String getCountry() {
        return country;
    }

    public int getPriority() {
        return priority;
    }

    public Timestamp getLastCheck() {
        return lastCheck;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(id=" + id + ", " +
                "developerAppleId=" + developerAppleId + ", " +
                "developerName=\"" + developerName + "\", " +
                "country=" + country + ", " +
                "priority=" + priority + ", " +
                "lastCheck=" + lastCheck + ")";
    }
}
