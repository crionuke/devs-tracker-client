package com.crionuke.devstracker.robots;

import com.crionuke.devstracker.core.actions.*;
import com.crionuke.devstracker.core.api.apple.AppleApi;
import com.crionuke.devstracker.core.dto.App;
import com.crionuke.devstracker.core.dto.CheckForUpdate;
import com.crionuke.devstracker.core.dto.SearchApp;
import com.crionuke.devstracker.core.exceptions.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Flux;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

@Component
@EnableScheduling
@SpringBootApplication
@ComponentScan("com.crionuke.devstracker.robots")
@ComponentScan("com.crionuke.devstracker.core")
public class Checker {
    private static final Logger logger = LoggerFactory.getLogger(Checker.class);

    static {
        System.setProperty("spring.profiles.active", "checker");
    }

    public static void main(String[] args) {
        SpringApplication.run(Checker.class, args);
    }

    private final DataSource dataSource;
    private final AppleApi appleApi;

    public Checker(DataSource dataSource, AppleApi appleApi) {
        this.dataSource = dataSource;
        this.appleApi = appleApi;
    }

    @Scheduled(fixedRate = 6000)
    public void check() {
        try (Connection connection = dataSource.getConnection()) {
            connection.setAutoCommit(false);
            try {
                SelectCheckForUpdate selectCheckForUpdate = new SelectCheckForUpdate(connection);
                CheckForUpdate checkForUpdate = selectCheckForUpdate.getCheckForUpdate();
                // Lookup developer for apps
                List<SearchApp> apps = appleApi
                        .lookupDeveloper(checkForUpdate.getDeveloperAppleId(), checkForUpdate.getCountry())
                        .flatMapMany(response -> Flux.fromIterable(response.getResults()))
                        .filter(result -> result.getWrapperType().equals("software"))
                        .map(result ->
                                new SearchApp(result.getTrackId(), result.getTrackCensoredName(),
                                        result.getTrackViewUrl(), result.getReleaseDate()))
                        .collectList()
                        .block();
                logger.debug("Apps, developerId={}, {}", checkForUpdate.getDeveloperAppleId(), apps);
                for (SearchApp searchApp : apps) {
                    App app;
                    try {
                        SelectApp selectApp = new SelectApp(connection, searchApp.getAppleId());
                        app = selectApp.getApp();
                    } catch (AppNotFoundException e1) {
                        try {
                            InsertApp insertApp = new InsertApp(connection, searchApp.getAppleId(),
                                    searchApp.getReleaseDate(), checkForUpdate.getDeveloperAppleId());
                            app = insertApp.getApp();
                            if (searchApp.getReleaseDate().getTime() > checkForUpdate.getDeveloperAdded().getTime()) {
                                // Safe notification
                                try {
                                    InsertNotification insertNotification =
                                            new InsertNotification(connection, insertApp.getApp().getId());
                                    logger.info("New released app detected, " +
                                                    "releaseDate={} > lastCheck={}, " +
                                                    "notificationId={}",
                                            searchApp.getReleaseDate().getTime(),
                                            checkForUpdate.getDeveloperAdded().getTime(),
                                            insertNotification.getNotification().getId());
                                } catch (NotificationAlreadyAddedException e) {
                                    logger.info(e.getMessage(), e);
                                }
                            }
                        } catch (AppAlreadyAddedException e2) {
                            logger.debug(e2.getMessage());
                            continue;
                        }
                    }
                    // Link app with country
                    try {
                        SelectLink selectLink = new SelectLink(connection, app.getId(), checkForUpdate.getCountry());
                    } catch (LinkNotFoundException e1) {
                        try {
                            InsertLink insertLink = new InsertLink(connection, app.getId(), searchApp.getTitle(),
                                    checkForUpdate.getCountry(), searchApp.getUrl());
                        } catch (LinkAlreadyAddedException e2) {
                            logger.debug(e2.getMessage());
                        }
                    }
                }
                UpdateCheck updateCheck = new UpdateCheck(connection, checkForUpdate.getId());
                connection.commit();
            } catch (CheckForUpdateNotFoundException e) {
                logger.info(e.getMessage());
                rollbackNoException(connection);
            } catch (InternalServerException e) {
                logger.warn(e.getMessage(), e);
                rollbackNoException(connection);
            }
        } catch (SQLException e) {
            logger.warn("Datasource unavailable, " + e.getMessage(), e);
        }
    }

    private void rollbackNoException(Connection connection) {
        try {
            connection.rollback();
        } catch (SQLException e) {
            logger.warn("Rollback failed, {}", e.getMessage(), e);
        }
    }
}
