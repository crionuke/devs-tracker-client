package com.crionuke.devstracker.server.services;

import com.crionuke.devstracker.server.api.AppleSearchApi;
import com.crionuke.devstracker.server.controllers.dto.SearchDeveloper;
import com.crionuke.devstracker.server.exceptions.*;
import com.crionuke.devstracker.server.services.actions.InsertDeveloper;
import com.crionuke.devstracker.server.services.actions.InsertTracker;
import com.crionuke.devstracker.server.services.actions.SelectDeveloper;
import com.crionuke.devstracker.server.services.dto.Developer;
import com.crionuke.devstracker.server.services.dto.Tracker;
import com.crionuke.devstracker.server.services.dto.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Flux;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class DeveloperService {
    private static final Logger logger = LoggerFactory.getLogger(DeveloperService.class);

    private final DataSource dataSource;
    private final AppleSearchApi appleSearchApi;

    private final Map<Long, SearchDeveloper> searchCache;

    DeveloperService(DataSource dataSource, AppleSearchApi appleSearchApi) {
        this.dataSource = dataSource;
        this.appleSearchApi = appleSearchApi;
        searchCache = new ConcurrentHashMap<>();
    }

    public List<SearchDeveloper> search(List<String> countries, String term) {
        // TODO: Check arguments
        List<SearchDeveloper> developers = appleSearchApi
                .searchDeveloper(countries, term)
                .flatMap(response -> Flux.fromIterable(response.getResults()))
                .map(result -> new SearchDeveloper(result.getArtistId(), result.getArtistName()))
                .distinct()
                .take(8)
                .collectList()
                .block();
        // Cache results
        developers.stream().forEach(developer -> searchCache.put(developer.getId(), developer));
        return developers;
    }

    public void track(User user, long developerAppleId) throws
            DeveloperNotCachedException, TrackerAlreadyAddedException, InternalServerException {
        // TODO: Check arguments
        try (Connection connection = dataSource.getConnection()) {
            connection.setAutoCommit(false);
            try {
                Developer developer = selectOrAddDeveloperFromCache(connection, developerAppleId);
                InsertTracker insertTracker = new InsertTracker(connection, user.getId(), developer.getId());
                Tracker tracker = insertTracker.getTracker();
                // Commit
                connection.commit();
            } catch (DeveloperNotCachedException | TrackerAlreadyAddedException | InternalServerException e) {
                rollbackNoException(connection);
                throw e;
            }
        } catch (SQLException e) {
            throw new InternalServerException("Datasource unavailable, " + e.getMessage(), e);
        }
    }

    private Developer selectOrAddDeveloperFromCache(Connection connection, long developerAppleId)
            throws DeveloperNotCachedException, InternalServerException {
        try {
            SelectDeveloper selectDeveloper = new SelectDeveloper(connection, developerAppleId);
            return selectDeveloper.getDeveloper();
        } catch (DeveloperNotFoundException e1) {
            SearchDeveloper searchDeveloper = searchCache.get(developerAppleId);
            if (searchDeveloper != null) {
                try {
                    InsertDeveloper insertDeveloper =
                            new InsertDeveloper(connection, searchDeveloper.getId(), searchDeveloper.getName());
                    return insertDeveloper.getDeveloper();
                } catch (DeveloperAlreadyAddedException e2) {
                    try {
                        SelectDeveloper selectDeveloper = new SelectDeveloper(connection, developerAppleId);
                        return selectDeveloper.getDeveloper();
                    } catch (DeveloperNotFoundException e3) {
                        throw new InternalServerException("Wrong internal state around developer, " +
                                "developerAppleId=" + developerAppleId);
                    }
                }
            } else {
                // TODO: search by apple api???
                throw new DeveloperNotCachedException("Developer not cached, try search again, " +
                        "developerAppleId=" + developerAppleId);
            }
        }
    }

    private void rollbackNoException(Connection connection) {
        try {
            connection.rollback();
        } catch (SQLException e) {
            logger.warn("Rollback failed, {}", e.getMessage(), e);
        }
    }

    // TODO: schedule cache cleanup procecure
}
