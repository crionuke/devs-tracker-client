package com.crionuke.devstracker.robot;

import com.crionuke.devstracker.core.actions.SelectCheckForUpdate;
import com.crionuke.devstracker.core.actions.UpdateCheck;
import com.crionuke.devstracker.core.api.apple.AppleApi;
import com.crionuke.devstracker.core.dto.CheckForUpdate;
import com.crionuke.devstracker.core.dto.SearchApp;
import com.crionuke.devstracker.core.dto.SearchDeveloper;
import com.crionuke.devstracker.core.exceptions.CheckForUpdateNotFoundException;
import com.crionuke.devstracker.core.exceptions.InternalServerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Flux;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
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
                        .map(result -> new SearchApp(result.getTrackId(), result.getTrackCensoredName(), result.getReleaseDate()))
                        .collectList()
                        .block();
                logger.debug("Apps, {}", apps);

                for (SearchApp app : apps) {
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
