package com.crionuke.devstracker.server.services.actions;

import com.crionuke.devstracker.server.exceptions.AnonymousUserAlreadyCreatedException;
import com.crionuke.devstracker.server.exceptions.InternalServerException;
import com.crionuke.devstracker.server.services.dto.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class InsertAnonymousUser {
    private static final Logger logger = LoggerFactory.getLogger(InsertAnonymousUser.class);

    private final String INSERT_SQL = "INSERT INTO users (u_anonymous_id) VALUES(?)";

    private final User user;

    public InsertAnonymousUser(Connection connection, String anonymousId)
            throws AnonymousUserAlreadyCreatedException, InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(INSERT_SQL,
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, anonymousId);
            statement.execute();
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    long id = generatedKeys.getLong("u_id");
                    long created = generatedKeys.getTimestamp("u_created").getTime();
                    user = new User(id, created, anonymousId);
                    logger.debug("Anonymous user created, anonymousId={}", anonymousId);
                } else {
                    throw new InternalServerException("Generated key not found");
                }
            }
        } catch (SQLException e) {
            if (e.getSQLState().equals("23505")) {
                throw new AnonymousUserAlreadyCreatedException("Anonymous user already created, " +
                        "anonymousId=" + anonymousId, e);
            } else {
                throw new InternalServerException("Transaction failed, " + e.getMessage(), e);
            }
        }
    }

    public User getUser() {
        return user;
    }
}
