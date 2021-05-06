package com.crionuke.devstracker.actions;

import com.crionuke.devstracker.actions.dto.Developer;
import com.crionuke.devstracker.exceptions.DeveloperAlreadyAddedException;
import com.crionuke.devstracker.exceptions.InternalServerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;

public class InsertDeveloper {
    private static final Logger logger = LoggerFactory.getLogger(InsertDeveloper.class);

    private final String INSERT_SQL = "INSERT INTO developers (d_apple_id, d_name) VALUES(?, ?)";

    private final Developer developer;

    public InsertDeveloper(Connection connection, long appleId, String name)
            throws DeveloperAlreadyAddedException, InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(INSERT_SQL,
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            statement.setLong(1, appleId);
            statement.setString(2, name);
            statement.execute();
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    long id = generatedKeys.getLong("d_id");
                    Timestamp added = generatedKeys.getTimestamp("d_added");
                    developer = new Developer(id, added, appleId, name);
                    logger.debug("Developer added, {}", developer);
                } else {
                    throw new InternalServerException("Generated key not found");
                }
            }
        } catch (SQLException e) {
            if (e.getSQLState().equals("23505")) {
                throw new DeveloperAlreadyAddedException("Developer already added, appleId=" + appleId, e);
            } else {
                throw new InternalServerException("Transaction failed, " + e.getMessage(), e);
            }
        }
    }

    public Developer getDeveloper() {
        return developer;
    }
}
