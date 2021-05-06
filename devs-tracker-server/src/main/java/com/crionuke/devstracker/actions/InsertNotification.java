package com.crionuke.devstracker.actions;

import com.crionuke.devstracker.actions.dto.Notification;
import com.crionuke.devstracker.exceptions.InternalServerException;
import com.crionuke.devstracker.exceptions.NotificationAlreadyAddedException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;

public class InsertNotification {
    private static final Logger logger = LoggerFactory.getLogger(InsertNotification.class);

    private final String INSERT_SQL = "INSERT INTO notifications (n_app_id) VALUES(?)";

    private final Notification notification;

    public InsertNotification(Connection connection, long appId)
            throws NotificationAlreadyAddedException, InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(INSERT_SQL,
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            statement.setLong(1, appId);
            statement.execute();
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    long id = generatedKeys.getLong("n_id");
                    Timestamp added = generatedKeys.getTimestamp("n_added");
                    boolean processed = generatedKeys.getBoolean("n_processed");
                    Timestamp updated = generatedKeys.getTimestamp("n_updated");
                    notification = new Notification(id, added, appId, processed, updated);
                    logger.debug("Notification added, {}", notification);
                } else {
                    throw new InternalServerException("Generated key not found");
                }
            }
        } catch (SQLException e) {
            if (e.getSQLState().equals("23505")) {
                throw new NotificationAlreadyAddedException("Notification already added, appId=" + appId, e);
            } else {
                throw new InternalServerException("Transaction failed, " + e.getMessage(), e);
            }
        }
    }

    public Notification getNotification() {
        return notification;
    }
}
