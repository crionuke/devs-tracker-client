package com.crionuke.devstracker.core.api.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.ArrayList;
import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class AppleSearchResponse {
    private int resultCount;
    private List<AppleSearchResult> results;

    public AppleSearchResponse() {
        resultCount = 0;
        results = new ArrayList<>();
    }

    public int getResultCount() {
        return resultCount;
    }

    public void setResultCount(int resultCount) {
        this.resultCount = resultCount;
    }

    public List<AppleSearchResult> getResults() {
        return results;
    }

    public void setResults(List<AppleSearchResult> results) {
        this.results = results;
    }
}