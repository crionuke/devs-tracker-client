package com.crionuke.devstracker.server.services;

import com.crionuke.devstracker.server.exceptions.ForbiddenRequestException;
import com.crionuke.devstracker.server.exceptions.InternalServerException;
import com.crionuke.devstracker.server.exceptions.UserAlreadyCreatedException;
import com.crionuke.devstracker.server.exceptions.UserNotFoundException;
import com.crionuke.devstracker.server.services.actions.InsertUser;
import com.crionuke.devstracker.server.services.actions.SelectUser;
import com.crionuke.devstracker.server.services.dto.User;
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

    private final DataSource dataSource;

    UserService(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public User selectUser(HttpHeaders headers) throws ForbiddenRequestException, InternalServerException {
        String header = headers.getFirst("Authorization");
        if (header == null || !header.startsWith("Bearer ")) {
            throw new ForbiddenRequestException("Authorization header not found");
        } else {
            String token = header.replace("Bearer ", "");
            try (Connection connection = dataSource.getConnection()) {
                try {
                    SelectUser selectUser = new SelectUser(connection, token);
                    User user = selectUser.getUser();
                    logger.debug("User authenticated, {}", user);
                    return user;
                } catch (UserNotFoundException e) {
                    throw new ForbiddenRequestException("User token not found, token=" + token);
                }
            } catch (SQLException e) {
                throw new InternalServerException("Datasource unavailable, " + e.getMessage(), e);
            }
        }
    }

    public void createUser(String token) throws UserAlreadyCreatedException, InternalServerException {
        try(Connection connection = dataSource.getConnection()) {
            InsertUser insertUser = new InsertUser(connection, token);
        } catch (SQLException e) {
            throw new InternalServerException("Datasource unavailable, " + e.getMessage(), e);
        }
    }
}

