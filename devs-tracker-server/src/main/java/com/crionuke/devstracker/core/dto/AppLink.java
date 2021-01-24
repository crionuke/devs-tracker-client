package com.crionuke.devstracker.core.dto;

public class AppLink {

    private final String title;
    private final String country;

    public AppLink(String title, String country) {
        this.title = title;
        this.country = country;
    }

    public String getTitle() {
        return title;
    }

    public String getCountry() {
        return country;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(title=" + title + ", " +
                "country=\"" + country + "\")";
    }
}
