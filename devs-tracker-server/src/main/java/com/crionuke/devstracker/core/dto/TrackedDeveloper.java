package com.crionuke.devstracker.core.dto;

import java.sql.Timestamp;

public class TrackedDeveloper {

    private final long added;
    private final long appleId;
    private final String name;

    public TrackedDeveloper(Timestamp added, long appleId, String name) {
        this.added = added.getTime();
        this.appleId = appleId;
        this.name = name;
    }

    public long getAdded() {
        return added;
    }

    public long getAppleId() {
        return appleId;
    }

    public String getName() {
        return name;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(added=" + added + ", " +
                "appleId=" + appleId + ", " +
                "name=\"" + name + "\")";
    }
}
