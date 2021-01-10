package com.crionuke.devstracker.server.controllers.dto;

import com.crionuke.devstracker.server.services.dto.SearchDeveloper;

import java.util.List;

public class SearchResponse {

    private final int count;
    private final List<SearchDeveloper> searchDevelopers;

    public SearchResponse(int count, List<SearchDeveloper> searchDevelopers) {
        this.count = count;
        this.searchDevelopers = searchDevelopers;
    }

    public int getCount() {
        return count;
    }

    public List<SearchDeveloper> getSearchDevelopers() {
        return searchDevelopers;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(count=\"" + count + "\", " +
                "searchDevelopers=" + searchDevelopers + ")";
    }
}
