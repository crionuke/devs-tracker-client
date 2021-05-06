package com.crionuke.devstracker.actions;

import com.crionuke.devstracker.actions.dto.TrackedDeveloper;
import com.crionuke.devstracker.exceptions.InternalServerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SelectTrackedDevelopers {
    private static final Logger logger = LoggerFactory.getLogger(SelectTrackedDevelopers.class);

    private final String SELECT_SQL = "" +
            "SELECT t_added, d_apple_id, d_name, COUNT(a_apple_id) AS a_count FROM trackers " +
            "INNER JOIN developers ON t_developer_id = d_id " +
            "LEFT JOIN apps ON d_id = a_developer_id AND a_release_date > t_last_view " +
            "WHERE t_user_id = ? " +
            "GROUP BY d_id, t_added";

    private List<TrackedDeveloper> trackedDevelopers;

    public SelectTrackedDevelopers(Connection connection, long userId) throws InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(SELECT_SQL)) {
            statement.setLong(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                trackedDevelopers = new ArrayList<>();
                while (resultSet.next()) {
                    Timestamp trackerAdded = resultSet.getTimestamp(1);
                    long developerAppleId = resultSet.getLong(2);
                    String developerName = resultSet.getString(3);
                    long appsCount = resultSet.getLong(4);
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
