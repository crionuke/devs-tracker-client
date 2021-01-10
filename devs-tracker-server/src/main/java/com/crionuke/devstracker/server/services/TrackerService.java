package com.crionuke.devstracker.server.services;

import com.crionuke.devstracker.server.exceptions.*;
import com.crionuke.devstracker.server.services.actions.*;
import com.crionuke.devstracker.server.services.api.AppleSearchApi;
import com.crionuke.devstracker.server.services.dto.*;
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
public class TrackerService {
    private static final Logger logger = LoggerFactory.getLogger(TrackerService.class);

    private final DataSource dataSource;
    private final DeveloperService developerService;

    TrackerService(DataSource dataSource, DeveloperService developerService) {
        this.dataSource = dataSource;
        this.developerService = developerService;
    }

    public List<TrackedDeveloper> getDevelopers(User user) throws InternalServerException {
        try (Connection connection = dataSource.getConnection()) {
            try {
                SelectTrackedDevelopers selectTrackedDevelopers = new SelectTrackedDevelopers(connection, user.getId());
                return selectTrackedDevelopers.getTrackedDevelopers();
            } catch (InternalServerException e) {
                throw e;
            }
        } catch (SQLException e) {
            throw new InternalServerException("Datasource unavailable, " + e.getMessage(), e);
        }
    }

    public void trackDeveloper(User user, long developerAppleId) throws
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

    public void deleteTracker(User user, long developerAppleId) throws
            DeveloperNotFoundException, TrackerNotFoundException, InternalServerException {
        // TODO: Check arguments
        try (Connection connection = dataSource.getConnection()) {
            connection.setAutoCommit(false);
            try {
                SelectDeveloper selectDeveloper = new SelectDeveloper(connection, developerAppleId);
                Developer developer = selectDeveloper.getDeveloper();
                DeleteTracker deleteTracker = new DeleteTracker(connection, user.getId(), developer.getId());
                // Commit
                connection.commit();
            } catch (DeveloperNotFoundException | InternalServerException e) {
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
            SearchDeveloper searchDeveloper = developerService.getSearchCache().get(developerAppleId);
            if (searchDeveloper != null) {
                try {
                    InsertDeveloper insertDeveloper =
                            new InsertDeveloper(connection, searchDeveloper.getAppleId(), searchDeveloper.getName());
                    return insertDeveloper.getDeveloper();
                } catch (DeveloperAlreadyAddedException e2) {
                    try {
                        SelectDeveloper selectDeveloper = new SelectDeveloper(connection, developerAppleId);
                        return selectDeveloper.getDeveloper();
                    } catch (DeveloperNotFoundException e3) {
                        throw new InternalServerException("Wrong internal state around searchDeveloper, " +
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

    // TODO: schedule cache cleanup procedure
}
