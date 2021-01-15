package com.crionuke.devstracker.core.actions;

import com.crionuke.devstracker.core.exceptions.InternalServerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class InsertDefaultChecks {
    private static final Logger logger = LoggerFactory.getLogger(InsertDefaultChecks.class);

    private final String[] COUNTRIES = {"ru", "us"};

    private final String INSERT_SQL = "INSERT INTO checks " +
            "(c_developer_id, c_country, c_priority) VALUES(?, ?, ?)";

    public InsertDefaultChecks(Connection connection, long developerId) throws InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(INSERT_SQL,
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            statement.setLong(1, developerId);
            int priority = 0;
            for (String country : COUNTRIES) {
                statement.setString(2, country);
                statement.setInt(3, priority++);
                statement.addBatch();
            }
            statement.executeBatch();
            logger.debug("Default checks inserted, developerId={}, {}", developerId, COUNTRIES);
        } catch (SQLException e) {
            throw new InternalServerException("Transaction failed, " + e.getMessage(), e);
        }
    }
}