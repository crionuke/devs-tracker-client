package com.crionuke.devstracker.server.dto;

public class SearchRequest {

    private String name;

    SearchRequest() {
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return SearchRequest.class.getSimpleName() + "(name=\"" + name + "\")";
    }
}
