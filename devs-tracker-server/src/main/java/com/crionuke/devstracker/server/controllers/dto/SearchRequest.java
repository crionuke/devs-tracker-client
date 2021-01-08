package com.crionuke.devstracker.server.controllers.dto;

import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

public class SearchRequest {
    static private AtomicLong counter = new AtomicLong(1);

    private final long rquid;

    private List<String> countries;
    private String term;

    SearchRequest() {
        rquid = counter.incrementAndGet();
    }

    public long getRquid() {
        return rquid;
    }

    public String getTerm() {
        return term;
    }

    public void setTerm(String term) {
        this.term = term;
    }

    public List<String> getCountries() {
        return countries;
    }

    public void setCountries(List<String> countries) {
        this.countries = countries;
    }

    @Override
    public String toString() {
        return SearchRequest.class.getSimpleName() + "(rquid=" + rquid + ", " +
                "countries=\"" + countries + "\", " +
                "term=\"" + term + "\")";
    }
}
