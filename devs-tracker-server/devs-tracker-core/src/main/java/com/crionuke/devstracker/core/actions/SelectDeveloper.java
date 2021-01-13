package com.crionuke.devstracker.core.actions;

import com.crionuke.devstracker.core.dto.Developer;
import com.crionuke.devstracker.core.exceptions.DeveloperNotFoundException;
import com.crionuke.devstracker.core.exceptions.InternalServerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SelectDeveloper {
    private static final Logger logger = LoggerFactory.getLogger(SelectDeveloper.class);

    private final String SELECT_SQL = "SELECT d_id, d_added, d_name FROM developers WHERE d_apple_id = ?";

    private final Developer developer;

    public SelectDeveloper(Connection connection, long appleId)
            throws DeveloperNotFoundException, InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(SELECT_SQL)) {
            statement.setLong(1, appleId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    long dId = resultSet.getLong(1);
                    long dAdded = resultSet.getTimestamp(2).getTime();
                    String dName = resultSet.getString(3);
                    developer = new Developer(dId, dAdded, appleId, dName);
                    logger.debug("Developer selected, {}", developer);
                } else {
                    throw new DeveloperNotFoundException("Developer not found, " + "appleId=" + appleId);
                }
            }
        } catch (SQLException e) {
            throw new InternalServerException("Transaction failed, " + e.getMessage(), e);
        }
    }

    public Developer getDeveloper() {
        return developer;
    }
}
