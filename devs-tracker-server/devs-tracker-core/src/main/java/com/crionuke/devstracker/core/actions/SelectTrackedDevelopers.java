package com.crionuke.devstracker.core.actions;

import com.crionuke.devstracker.core.dto.TrackedDeveloper;
import com.crionuke.devstracker.core.exceptions.InternalServerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SelectTrackedDevelopers {
    private static final Logger logger = LoggerFactory.getLogger(SelectTrackedDevelopers.class);

    private final String SELECT_SQL = "SELECT t_added, d_apple_id, d_name " +
            "FROM trackers INNER JOIN developers " +
            "ON t_developer_id = d_id " +
            "WHERE t_user_id = ?";

    private List<TrackedDeveloper> trackedDevelopers;

    public SelectTrackedDevelopers(Connection connection, long userId) throws InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(SELECT_SQL)) {
            statement.setLong(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                trackedDevelopers = new ArrayList<>();
                while (resultSet.next()) {
                    long added = resultSet.getTimestamp(1).getTime();
                    long appleId = resultSet.getLong(2);
                    String name = resultSet.getString(3);
                    TrackedDeveloper trackedDeveloper = new TrackedDeveloper(added, appleId, name);
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
