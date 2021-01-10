package com.crionuke.devstracker.server.services.actions;

import com.crionuke.devstracker.server.exceptions.DeveloperAlreadyAddedException;
import com.crionuke.devstracker.server.exceptions.InternalServerException;
import com.crionuke.devstracker.server.exceptions.TrackerAlreadyAddedException;
import com.crionuke.devstracker.server.services.dto.Developer;
import com.crionuke.devstracker.server.services.dto.Tracker;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class InsertTracker {
    private static final Logger logger = LoggerFactory.getLogger(InsertTracker.class);

    private final String INSERT_SQL = "INSERT INTO trackers (t_user_id, t_developer_id) VALUES(?, ?)";

    private final Tracker tracker;

    public InsertTracker(Connection connection, long userId, long developerId)
            throws TrackerAlreadyAddedException, InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(INSERT_SQL,
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            statement.setLong(1, userId);
            statement.setLong(2, developerId);
            statement.execute();
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    long id = generatedKeys.getLong("t_id");
                    long added = generatedKeys.getTimestamp("t_added").getTime();
                    tracker = new Tracker(id, added, userId, developerId);
                    logger.debug("Tracker added, {}", tracker);
                } else {
                    throw new InternalServerException("Generated key not found");
                }
            }
        } catch (SQLException e) {
            if (e.getSQLState().equals("23505")) {
                throw new TrackerAlreadyAddedException("Tracker already added, " +
                        "userId=" + userId + ", developerId=" + developerId, e);
            } else {
                throw new InternalServerException("Transaction failed, " + e.getMessage(), e);
            }
        }
    }

    public Tracker getTracker() {
        return tracker;
    }
}
