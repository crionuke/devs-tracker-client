package com.crionuke.devstracker.actions;

import com.crionuke.devstracker.actions.dto.User;
import com.crionuke.devstracker.exceptions.InternalServerException;
import com.crionuke.devstracker.exceptions.UserNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class UpdateUserDevice {
    private static final Logger logger = LoggerFactory.getLogger(UpdateUserDevice.class);

    private final String UPDATE_SQL = "UPDATE users SET u_device = ? WHERE u_id = ?";

    private final User updatedUser;

    public UpdateUserDevice(Connection connection, User user, String newDevice)
            throws UserNotFoundException, InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(UPDATE_SQL)) {
            statement.setLong(1, user.getId());
            statement.setString(2, newDevice);
            statement.executeUpdate();
            if (statement.executeUpdate() == 0) {
                throw new UserNotFoundException("User not found, id=" + user.getId());
            } else {
                logger.debug("User updated, id={}, newDevice={}", user.getId(), newDevice);
                updatedUser = new User(user.getId(), user.getAdded(), user.getToken(), newDevice);
            }
        } catch (SQLException e) {
            throw new InternalServerException("Transaction failed, " + e.getMessage(), e);
        }
    }

    public User getUpdatedUser() {
        return updatedUser;
    }
}
