package com.crionuke.devstracker.core.dto;

import java.sql.Timestamp;

public class CheckForUpdate {

    private final long id;
    private final String country;
    private final int priority;
    private final Timestamp lastCheck;

    private final Developer developer;

    public CheckForUpdate(long id, String country, int priority, Timestamp lastCheck, Developer developer) {
        this.id = id;
        this.country = country;
        this.priority = priority;
        this.lastCheck = lastCheck;
        this.developer = developer;
    }

    public long getId() {
        return id;
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

    public Developer getDeveloper() {
        return developer;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(id=" + id + ", " +
                "country=" + country + ", " +
                "priority=" + priority + ", " +
                "lastCheck=\"" + lastCheck + "\"" +
                "developer=" + developer + ")";
    }
}
