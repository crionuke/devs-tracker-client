package com.crionuke.devstracker.core.actions;

import com.crionuke.devstracker.core.dto.User;
import com.crionuke.devstracker.core.exceptions.InternalServerException;
import com.crionuke.devstracker.core.exceptions.UserNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;

public class SelectUser {
    private static final Logger logger = LoggerFactory.getLogger(SelectUser.class);

    private final String SELECT_SQL = "SELECT u_id, u_added FROM users WHERE u_token = ?";

    private final User user;

    public SelectUser(Connection connection, String token)
            throws UserNotFoundException, InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(SELECT_SQL)) {
            statement.setString(1, token);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    long id = resultSet.getLong(1);
                    Timestamp added = resultSet.getTimestamp(2);
                    user = new User(id, added, token);
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
