package com.crionuke.devstracker.actions.dto;

import java.sql.Timestamp;

public class Check {

    final long id;
    final Timestamp added;
    final long developerId;
    final String country;
    final Timestamp lastCheck;

    public Check(long id, Timestamp added, long developerId, String country, Timestamp lastCheck) {
        this.id = id;
        this.added = added;
        this.developerId = developerId;
        this.country = country;
        this.lastCheck = lastCheck;
    }

    public long getId() {
        return id;
    }

    public Timestamp getAdded() {
        return added;
    }

    public long getDeveloperId() {
        return developerId;
    }

    public String getCountry() {
        return country;
    }

    public Timestamp getLastCheck() {
        return lastCheck;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(id=" + id + ", " +
                "added=\"" + added + "\", " +
                "developerId=" + developerId + ", " +
                "country=\"" + country + "\", " +
                "lastCheck=\"" + lastCheck + "\")";
    }
}
