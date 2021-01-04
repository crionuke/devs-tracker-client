package com.crionuke.devstracker.server.dto;

import java.util.ArrayList;
import java.util.List;

public class SearchResponse {
    private final int count;
    private final List<SearchDevelopers> developers;

    public SearchResponse() {
        this.count = 0;
        this.developers = new ArrayList<>();
    }

    public SearchResponse(int count, List<SearchDevelopers> developers) {
        this.count = count;
        this.developers = developers;
    }

    public int getCount() {
        return count;
    }

    public List<SearchDevelopers> getDevelopers() {
        return developers;
    }
}
