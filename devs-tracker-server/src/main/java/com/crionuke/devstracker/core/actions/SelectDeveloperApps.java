package com.crionuke.devstracker.core.actions;

import com.crionuke.devstracker.core.dto.DeveloperApp;
import com.crionuke.devstracker.core.exceptions.InternalServerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SelectDeveloperApps {
    private static final Logger logger = LoggerFactory.getLogger(SelectDeveloperApps.class);

    private final String SELECT_SQL = "SELECT a_apple_id, a_release_date, a_title FROM apps WHERE a_developer_id = ?";

    private final List<DeveloperApp> developerApps;

    public SelectDeveloperApps(Connection connection, long developerAppleId)
            throws InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(SELECT_SQL)) {
            statement.setLong(1, developerAppleId);
            try (ResultSet resultSet = statement.executeQuery()) {
                developerApps = new ArrayList<>();
                while (resultSet.next()) {
                    long appleId = resultSet.getLong(1);
                    Timestamp releaseDate = resultSet.getTimestamp(2);
                    String title = resultSet.getString(3);
                    DeveloperApp app = new DeveloperApp(appleId, releaseDate, title);
                    developerApps.add(app);
                }
            }
        } catch (SQLException e) {
            throw new InternalServerException("Transaction failed, " + e.getMessage(), e);
        }
    }

    public List<DeveloperApp> getDeveloperApps() {
        return developerApps;
    }
}
