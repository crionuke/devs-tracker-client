package com.crionuke.devstracker.server.controllers.dto;

public class TrackRequest {

    private String anonymousId;

    public String getAnonymousId() {
        return anonymousId;
    }

    public void setAnonymousId(String anonymousId) {
        this.anonymousId = anonymousId;
    }

    @Override
    public String toString() {
        return SearchRequest.class.getSimpleName() + "(anonymousId=\"" + anonymousId + "\")";
    }
}
