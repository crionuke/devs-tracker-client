package com.crionuke.devstracker.api.revenueCat;

import com.crionuke.devstracker.api.revenueCat.dto.RevenueCatResponse;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class RevenueCatApiTest {
    private static final Logger logger = LoggerFactory.getLogger(RevenueCatApiTest.class);

    @Test
    public void getSubscriberTest() {
        RevenueCatApi revenueCatApi = new RevenueCatApi("QcsNMFNHlhaJmTxHTCXMoaglosdSUCXo");
        String appUserId = "$RCAnonymousID:d973a108faac470d83d34a800043de51";
        RevenueCatResponse revenueCatResponse = revenueCatApi.getSubscriber(appUserId).block();
        logger.info("Got subscriber, {}", revenueCatResponse);
    }
}
