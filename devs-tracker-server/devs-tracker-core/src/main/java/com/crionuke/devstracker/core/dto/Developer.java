package com.crionuke.devstracker.core.dto;

public class Developer {

    private final long id;
    private final long added;
    private final long appleId;
    private final String name;

    public Developer(long id, long added, long appleId, String name) {
        this.id = id;
        this.added = added;
        this.appleId = appleId;
        this.name = name;
    }

    public long getId() {
        return id;
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
        return getClass().getSimpleName() + "(id=" + id + ", " +
                "added=" + added + ", " +
                "appleId=" + appleId + ", " +
                "name=\"" + name + "\")";
    }
}
