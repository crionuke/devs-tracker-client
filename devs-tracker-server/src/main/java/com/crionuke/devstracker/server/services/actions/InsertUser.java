package com.crionuke.devstracker.server.services.actions;

import com.crionuke.devstracker.server.exceptions.UserAlreadyCreatedException;
import com.crionuke.devstracker.server.exceptions.InternalServerException;
import com.crionuke.devstracker.server.services.dto.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class InsertUser {
    private static final Logger logger = LoggerFactory.getLogger(InsertUser.class);

    private final String INSERT_SQL = "INSERT INTO users (u_token) VALUES(?)";

    private final User user;

    public InsertUser(Connection connection, String token)
            throws UserAlreadyCreatedException, InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(INSERT_SQL,
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, token);
            statement.execute();
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    long id = generatedKeys.getLong("u_id");
                    long created = generatedKeys.getTimestamp("u_created").getTime();
                    user = new User(id, created, token);
                    logger.debug("User created, {}", user);
                } else {
                    throw new InternalServerException("Generated key not found");
                }
            }
        } catch (SQLException e) {
            if (e.getSQLState().equals("23505")) {
                throw new UserAlreadyCreatedException("User already created, token=" + token, e);
            } else {
                throw new InternalServerException("Transaction failed, " + e.getMessage(), e);
            }
        }
    }

    public User getUser() {
        return user;
    }
}
