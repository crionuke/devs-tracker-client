package com.crionuke.devstracker.server.services.actions;

import com.crionuke.devstracker.server.exceptions.UserNotFoundException;
import com.crionuke.devstracker.server.exceptions.InternalServerException;
import com.crionuke.devstracker.server.services.dto.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SelectUser {
    private static final Logger logger = LoggerFactory.getLogger(SelectUser.class);

    private final String SELECT_SQL = "SELECT u_id, u_created FROM users WHERE u_token = ?";

    private final User user;

    public SelectUser(Connection connection, String token)
            throws UserNotFoundException, InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(SELECT_SQL)) {
            statement.setString(1, token);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    long uId = resultSet.getLong(1);
                    long uCreated = resultSet.getTimestamp(2).getTime();
                    user = new User(uId, uCreated, token);
                    logger.debug("User selected, {}", user);
                } else {
                    throw new UserNotFoundException("User not found, token=" + token);
                }
            }
        } catch (SQLException e) {
            throw new InternalServerException("Transaction failed, " + e.getMessage(), e);
        }
    }

    public User getUser() {
        return user;
    }
}
