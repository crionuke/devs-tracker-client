package com.crionuke.devstracker.controllers.dto;

import java.util.List;

public class AppResponse {

    private final List<String> countries;

    public AppResponse(List<String> countries) {
        this.countries = countries;
    }

    public List<String> getCountries() {
        return countries;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(countries=" + countries + ")";
    }
}
