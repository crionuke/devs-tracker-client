package com.crionuke.devstracker.core.actions;

import com.crionuke.devstracker.core.dto.User;
import com.crionuke.devstracker.core.exceptions.InternalServerException;
import com.crionuke.devstracker.core.exceptions.UserAlreadyAddedException;
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
            throws UserAlreadyAddedException, InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(INSERT_SQL,
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, token);
            statement.execute();
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    long id = generatedKeys.getLong("u_id");
                    long added = generatedKeys.getTimestamp("u_added").getTime();
                    user = new User(id, added, token);
                    logger.info("User added, {}", user);
                } else {
                    throw new InternalServerException("Generated key not found");
                }
            }
        } catch (SQLException e) {
            if (e.getSQLState().equals("23505")) {
                throw new UserAlreadyAddedException("User already added, token=" + token, e);
            } else {
                throw new InternalServerException("Transaction failed, " + e.getMessage(), e);
            }
        }
    }

    public User getUser() {
        return user;
    }
}
