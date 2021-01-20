package com.crionuke.devstracker.core.actions;

import com.crionuke.devstracker.core.dto.App;
import com.crionuke.devstracker.core.exceptions.AppNotFoundException;
import com.crionuke.devstracker.core.exceptions.InternalServerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;

public class SelectApp {
    private static final Logger logger = LoggerFactory.getLogger(SelectApp.class);

    private final String SELECT_SQL = "SELECT a_id, a_added, a_release_date, a_title, a_developer_id " +
            "FROM apps WHERE a_apple_id = ?";

    private final App app;

    public SelectApp(Connection connection, long appAppleId)
            throws AppNotFoundException, InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(SELECT_SQL)) {
            statement.setLong(1, appAppleId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    long id = resultSet.getLong(1);
                    Timestamp added = resultSet.getTimestamp(2);
                    Timestamp releaseDate = resultSet.getTimestamp(3);
                    String title = resultSet.getString(4);
                    long developerId = resultSet.getLong(5);
                    app = new App(id, added, appAppleId, releaseDate, title, developerId);
                    logger.debug("App selected, {}", app);
                } else {
                    throw new AppNotFoundException("App not found, " + "appAppleId=" + appAppleId);
                }
            }
        } catch (SQLException e) {
            throw new InternalServerException("Transaction failed, " + e.getMessage(), e);
        }
    }

    public App getApp() {
        return app;
    }
}
