package com.crionuke.devstracker.server.services.actions;

import com.crionuke.devstracker.server.exceptions.AnonymousUserNotFoundException;
import com.crionuke.devstracker.server.exceptions.InternalServerException;
import com.crionuke.devstracker.server.services.dto.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SelectAnonymousUser {
    private static final Logger logger = LoggerFactory.getLogger(SelectAnonymousUser.class);

    private final String SELECT_SQL = "SELECT u_id, u_created FROM users WHERE u_anonymous_id = ?";

    private final User user;

    public SelectAnonymousUser(Connection connection, String anonymousId)
            throws AnonymousUserNotFoundException, InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(SELECT_SQL)) {
            statement.setString(1, anonymousId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    long uId = resultSet.getLong(1);
                    long uCreated = resultSet.getTimestamp(2).getTime();
                    user = new User(uId, uCreated, anonymousId);
                    logger.debug("User selected, {}", user);
                } else {
                    throw new AnonymousUserNotFoundException("Anonymous user not found, " +
                            "anonymousId=" + anonymousId);
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
