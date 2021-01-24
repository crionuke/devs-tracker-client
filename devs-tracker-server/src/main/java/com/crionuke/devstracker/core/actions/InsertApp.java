package com.crionuke.devstracker.core.actions;

import com.crionuke.devstracker.core.dto.App;
import com.crionuke.devstracker.core.dto.Developer;
import com.crionuke.devstracker.core.exceptions.AppAlreadyAddedException;
import com.crionuke.devstracker.core.exceptions.DeveloperAlreadyAddedException;
import com.crionuke.devstracker.core.exceptions.InternalServerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;

public class InsertApp {
    private static final Logger logger = LoggerFactory.getLogger(InsertApp.class);

    private final String INSERT_SQL = "INSERT INTO apps (a_apple_id, a_release_date, a_developer_id) " +
            "VALUES(?, ?, ?)";

    private final App app;

    public InsertApp(Connection connection, long appleId, Timestamp releaseDate, long developerId)
            throws AppAlreadyAddedException, InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(INSERT_SQL,
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            statement.setLong(1, appleId);
            statement.setTimestamp(2, releaseDate);
            statement.setLong(3, developerId);
            statement.execute();
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    long id = generatedKeys.getLong("a_id");
                    Timestamp added = generatedKeys.getTimestamp("a_added");
                    app = new App(id, added, appleId, releaseDate, developerId);
                    logger.info("App added, {}", app);
                } else {
                    throw new InternalServerException("Generated key not found");
                }
            }
        } catch (SQLException e) {
            if (e.getSQLState().equals("23505")) {
                throw new AppAlreadyAddedException("App already added, appleId=" + appleId, e);
            } else {
                throw new InternalServerException("Transaction failed, " + e.getMessage(), e);
            }
        }
    }

    public App getApp() {
        return app;
    }
}
