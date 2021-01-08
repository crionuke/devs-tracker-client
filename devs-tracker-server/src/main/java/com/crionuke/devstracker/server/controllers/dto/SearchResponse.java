package com.crionuke.devstracker.server.controllers.dto;

import java.util.ArrayList;
import java.util.List;

public class SearchResponse {
    private final int count;
    private final List<SearchDeveloper> developers;

    public SearchResponse() {
        this.count = 0;
        this.developers = new ArrayList<>();
    }

    public SearchResponse(int count, List<SearchDeveloper> developers) {
        this.count = count;
        this.developers = developers;
    }

    public int getCount() {
        return count;
    }

    public List<SearchDeveloper> getDevelopers() {
        return developers;
    }
}
