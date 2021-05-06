package com.crionuke.devstracker.services;

import com.crionuke.devstracker.actions.InsertUser;
import com.crionuke.devstracker.actions.SelectUser;
import com.crionuke.devstracker.actions.UpdateUserDevice;
import com.crionuke.devstracker.actions.dto.User;
import com.crionuke.devstracker.exceptions.ForbiddenRequestException;
import com.crionuke.devstracker.exceptions.InternalServerException;
import com.crionuke.devstracker.exceptions.UserAlreadyAddedException;
import com.crionuke.devstracker.exceptions.UserNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

@Component
public class UserService {
    private static final Logger logger = LoggerFactory.getLogger(UserService.class);

    private static final String AUTH_HEADER_NAME = "Authorization";
    private static final String AUTH_HEADER_PREFIX = "Bearer ";
    private static final String DEVICE_HEADER_NAME = "Device";

    private final DataSource dataSource;

    UserService(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public User authenticate(HttpHeaders headers) throws ForbiddenRequestException, InternalServerException {
        String header = headers.getFirst(AUTH_HEADER_NAME);
        if (header == null || !header.startsWith(AUTH_HEADER_PREFIX)) {
            throw new ForbiddenRequestException(AUTH_HEADER_NAME + " header not found");
        } else {
            String token = header.replace(AUTH_HEADER_PREFIX, "");
            String device = headers.getFirst(DEVICE_HEADER_NAME);
            if (device == null) {
                throw new ForbiddenRequestException(DEVICE_HEADER_NAME + " header not found");
            }
            return handleUser(token, device);
        }
    }

    private User handleUser(String token, String device) throws InternalServerException {
        try (Connection connection = dataSource.getConnection()) {
            try {
                SelectUser selectUser = new SelectUser(connection, token);
                // Update device if changed
                if (!selectUser.getUser().getDevice().equals(device)) {
                    UpdateUserDevice updateUserDevice =
                            new UpdateUserDevice(connection, selectUser.getUser(), device);
                    return updateUserDevice.getUpdatedUser();
                } else {
                    return selectUser.getUser();
                }
            } catch (UserNotFoundException e1) {
                try {
                    InsertUser insertUser = new InsertUser(connection, token, device);
                    return insertUser.getUser();
                } catch (UserAlreadyAddedException e2) {
                    try {
                        SelectUser selectUser = new SelectUser(connection, token);
                        return selectUser.getUser();
                    } catch (UserNotFoundException e3) {
                        throw new InternalServerException("Wrong internal state around user, token=" + token);
                    }
                }
            }
        } catch (SQLException e) {
            throw new InternalServerException("Datasource unavailable, " + e.getMessage(), e);
        }
    }
}

