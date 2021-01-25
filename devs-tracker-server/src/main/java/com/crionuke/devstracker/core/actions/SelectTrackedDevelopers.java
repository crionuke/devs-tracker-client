package com.crionuke.devstracker.core.actions;

import com.crionuke.devstracker.core.dto.TrackedDeveloper;
import com.crionuke.devstracker.core.exceptions.InternalServerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SelectTrackedDevelopers {
    private static final Logger logger = LoggerFactory.getLogger(SelectTrackedDevelopers.class);

    private final String SELECT_SQL = "" +
            "SELECT d_id, d_apple_id, d_name, t_added, COUNT(a_apple_id) AS a_count " +
            "FROM trackers " +
            "INNER JOIN developers ON t_developer_id = d_id " +
            "INNER JOIN apps ON d_id = a_developer_id " +
            "WHERE t_user_id = ? " +
            "GROUP BY d_id, t_added";

    private List<TrackedDeveloper> trackedDevelopers;

    public SelectTrackedDevelopers(Connection connection, long userId) throws InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(SELECT_SQL)) {
            statement.setLong(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                trackedDevelopers = new ArrayList<>();
                while (resultSet.next()) {
                    long developerAppleId = resultSet.getLong(2);
                    String developerName = resultSet.getString(3);
                    Timestamp trackerAdded = resultSet.getTimestamp(4);
                    long appsCount = resultSet.getLong(5);
                    TrackedDeveloper trackedDeveloper =
                            new TrackedDeveloper(trackerAdded, developerAppleId, developerName, appsCount);
                    trackedDevelopers.add(trackedDeveloper);
                }
            }
        } catch (SQLException e) {
            throw new InternalServerException("Transaction failed, " + e.getMessage(), e);
        }
    }

    public List<TrackedDeveloper> getTrackedDevelopers() {
        return trackedDevelopers;
    }
}
