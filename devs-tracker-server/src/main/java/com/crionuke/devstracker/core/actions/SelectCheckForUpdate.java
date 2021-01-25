package com.crionuke.devstracker.core.actions;

import com.crionuke.devstracker.core.dto.CheckForUpdate;
import com.crionuke.devstracker.core.dto.Developer;
import com.crionuke.devstracker.core.exceptions.CheckForUpdateNotFoundException;
import com.crionuke.devstracker.core.exceptions.InternalServerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;

public class SelectCheckForUpdate {
    private static final Logger logger = LoggerFactory.getLogger(SelectCheckForUpdate.class);

    private final String SELECT_SQL = "" +
            "SELECT c_id, c_country, c_priority, c_last_check, d_id, d_added, d_apple_id, d_name " +
            "FROM checks INNER JOIN developers ON c_developer_id = d_id " +
            "ORDER BY c_last_check, c_priority ASC " +
            "LIMIT 1 " +
            "FOR UPDATE OF checks SKIP LOCKED";

    private final CheckForUpdate checkForUpdate;

    public SelectCheckForUpdate(Connection connection) throws CheckForUpdateNotFoundException, InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(SELECT_SQL)) {
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    // Check's fields
                    long checkId = resultSet.getLong(1);
                    String country = resultSet.getString(2);
                    int priority = resultSet.getInt(3);
                    Timestamp lastCheck = resultSet.getTimestamp(4);
                    // Developer's fields
                    long developerId = resultSet.getLong(5);
                    Timestamp developerAdded = resultSet.getTimestamp(6);
                    long developerAppleId = resultSet.getLong(7);
                    String developerName = resultSet.getString(8);
                    Developer developer = new Developer(developerId, developerAdded, developerAppleId, developerName);
                    checkForUpdate = new CheckForUpdate(checkId, country, priority, lastCheck, developer);
                    logger.debug("Check for update selected, {}", checkForUpdate);
                } else {
                    throw new CheckForUpdateNotFoundException("Check for update not found");
                }
            }
        } catch (SQLException e) {
            throw new InternalServerException("Transaction failed, " + e.getMessage(), e);
        }
    }

    public CheckForUpdate getCheckForUpdate() {
        return checkForUpdate;
    }
}
