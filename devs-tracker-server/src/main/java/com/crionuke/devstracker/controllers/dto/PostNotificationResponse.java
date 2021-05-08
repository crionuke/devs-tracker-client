package com.crionuke.devstracker.controllers.dto;

public class PostNotificationResponse {

    private final boolean result;

    public PostNotificationResponse(boolean result) {
        this.result = result;
    }

    public boolean getResult() {
        return result;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(result=\"" + result + ")";
    }
}
