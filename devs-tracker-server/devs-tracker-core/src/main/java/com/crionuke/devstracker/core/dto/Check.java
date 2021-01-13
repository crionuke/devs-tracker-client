package com.crionuke.devstracker.core.dto;

public class Check {

    final long id;
    final long added;
    final long developerId;
    final String country;
    final long lastRun;

    public Check(long id, long added, long developerId, String country, long lastRun) {
        this.id = id;
        this.added = added;
        this.developerId = developerId;
        this.country = country;
        this.lastRun = lastRun;
    }

    public long getId() {
        return id;
    }

    public long getAdded() {
        return added;
    }

    public long getDeveloperId() {
        return developerId;
    }

    public String getCountry() {
        return country;
    }

    public long getLastRun() {
        return lastRun;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(id=" + id + ", " +
                "added=" + added + ", " +
                "developerId=" + developerId + ", " +
                "country=" + country + ", " +
                "lastRun=\"" + lastRun + "\")";
    }
}
