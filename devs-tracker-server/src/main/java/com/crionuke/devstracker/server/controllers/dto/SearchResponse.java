package com.crionuke.devstracker.server.controllers.dto;

import java.util.List;

public class SearchResponse {
    private final long rquid;
    private final int count;
    private final List<SearchDeveloper> developers;

    public SearchResponse(long rquid, int count, List<SearchDeveloper> developers) {
        this.rquid = rquid;
        this.count = count;
        this.developers = developers;
    }

    public long getRquid() {
        return rquid;
    }

    public int getCount() {
        return count;
    }

    public List<SearchDeveloper> getDevelopers() {
        return developers;
    }

    @Override
    public String toString() {
        return SearchRequest.class.getSimpleName() + "(rquid=" + rquid + ", " +
                "count=\"" + count + "\", " +
                "developers=" + developers + ")";
    }
}
