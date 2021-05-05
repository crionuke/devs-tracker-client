package com.crionuke.devstracker.core.api.revenueCat.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.Map;

@JsonIgnoreProperties(ignoreUnknown = true)
public class RevenueCatSubscriber {
    private Map<String, RevenueCatEntitlement> entitlements;

    public Map<String, RevenueCatEntitlement> getEntitlements() {
        return entitlements;
    }

    public void setEntitlements(Map<String, RevenueCatEntitlement> entitlements) {
        this.entitlements = entitlements;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(entitlements=" + entitlements + ")";
    }
}
