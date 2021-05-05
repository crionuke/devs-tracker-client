package com.crionuke.devstracker.core.api.revenueCat.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@JsonIgnoreProperties(ignoreUnknown = true)
public class RevenueCatEntitlement {
    private static final Logger logger = LoggerFactory.getLogger(RevenueCatEntitlement.class);

    @JsonProperty("expires_date")
    private Timestamp expiresDate;

    @JsonProperty("product_identifier")
    private String productIdentifier;

    @JsonProperty("purchase_date")
    private Timestamp purchaseDate;

    public Timestamp getExpiresDate() {
        return expiresDate;
    }

    public void setExpiresDate(String expiresDate) {
        try {
            Date date = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(expiresDate);
            this.expiresDate = new Timestamp(date.getTime());
        } catch (ParseException e) {
            logger.warn(e.getMessage(), e);
        }
    }

    public String getProductIdentifier() {
        return productIdentifier;
    }

    public void setProductIdentifier(String productIdentifier) {
        this.productIdentifier = productIdentifier;
    }

    public Timestamp getPurchaseDate() {
        return purchaseDate;
    }

    public void setPurchaseDate(String purchaseDate) {
        try {
            Date date = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(purchaseDate);
            this.purchaseDate = new Timestamp(date.getTime());
        } catch (ParseException e) {
            logger.warn(e.getMessage(), e);
        }
    }

    public boolean isActive() {
        return expiresDate.after(new Date());
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(expiresDate=" + expiresDate + ", " +
                "productIdentifier=" + productIdentifier + ", " +
                "purchaseDate=" + purchaseDate + ", " +
                "isActive=" + isActive() + ")";
    }
}
