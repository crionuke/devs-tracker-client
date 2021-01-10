package com.crionuke.devstracker.server.services.dto;

public class TrackedDeveloper {

    private final long added;
    private final long appleId;
    private final String name;

    public TrackedDeveloper(long added, long appleId, String name) {
        this.added = added;
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
