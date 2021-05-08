package com.crionuke.devstracker.robots;

import com.crionuke.devstracker.actions.*;
import com.crionuke.devstracker.actions.dto.App;
import com.crionuke.devstracker.actions.dto.CheckForUpdate;
import com.crionuke.devstracker.actions.dto.Developer;
import com.crionuke.devstracker.actions.dto.SearchApp;
import com.crionuke.devstracker.api.apple.AppleApi;
import com.crionuke.devstracker.exceptions.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Flux;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

@Component
public class Checker {
    private static final Logger logger = LoggerFactory.getLogger(Checker.class);

    private final DataSource dataSource;
    private final AppleApi appleApi;

    public Checker(DataSource dataSource, AppleApi appleApi) {
        this.dataSource = dataSource;
        this.appleApi = appleApi;
    }

    @Scheduled(fixedRate = 6000)
    public void run() {
        try (Connection connection = dataSource.getConnection()) {
            connection.setAutoCommit(false);
            try {
                SelectCheckForUpdate selectCheckForUpdate = new SelectCheckForUpdate(connection);
                CheckForUpdate checkForUpdate = selectCheckForUpdate.getCheckForUpdate();
                logger.debug("Handle {}", checkForUpdate);
                Developer developer = checkForUpdate.getDeveloper();
                // Lookup developer for apps
                List<SearchApp> apps = appleApi
                        .lookupDeveloper(developer.getAppleId(), checkForUpdate.getCountry())
                        .flatMapMany(response -> Flux.fromIterable(response.getResults()))
                        .filter(result -> result.getWrapperType().equals("software"))
                        .map(result ->
                                new SearchApp(result.getTrackId(), result.getTrackCensoredName(),
                                        result.getTrackViewUrl(), result.getReleaseDate()))
                        .collectList()
                        .block();
                logger.debug("Lookup developer, developerId={}, appsCount={}, apps={}",
                        developer.getId(), apps.size(), apps);
                for (SearchApp searchApp : apps) {
                    App app;
                    try {
                        SelectApp selectApp = new SelectApp(connection, searchApp.getAppleId());
                        app = selectApp.getApp();
                    } catch (AppNotFoundException e1) {
                        try {
                            InsertApp insertApp = new InsertApp(connection, searchApp.getAppleId(),
                                    searchApp.getReleaseDate(), developer.getId());
                            app = insertApp.getApp();
                            if (searchApp.getReleaseDate().getTime() > developer.getAdded().getTime()) {
                                // Safe notification
                                try {
                                    InsertNotification insertNotification =
                                            new InsertNotification(connection, developer.getId(), searchApp.getTitle());
                                    logger.info("New released app detected, " +
                                                    "releaseDate=\"{}\" > developerAdded=\"{}\", inserted notification={}",
                                            searchApp.getReleaseDate(), developer.getAdded(),
                                            insertNotification.getNotification());
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
                logger.debug(e.getMessage());
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
