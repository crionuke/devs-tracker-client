package com.crionuke.devstracker.server.controllers.dto;

import com.crionuke.devstracker.server.services.dto.TrackedDeveloper;

import java.util.List;

public class TrackedDevelopersResponse {

    private final int count;
    private final List<TrackedDeveloper> developers;

    public TrackedDevelopersResponse(int count, List<TrackedDeveloper> developers) {
        this.count = count;
        this.developers = developers;
    }

    public int getCount() {
        return count;
    }

    public List<TrackedDeveloper> getDevelopers() {
        return developers;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(count=\"" + count + "\", " +
                "developers=" + developers + ")";
    }
}
