package com.crionuke.devstracker.server.services;

import com.crionuke.devstracker.server.exceptions.AnonymousUserAlreadyCreatedException;
import com.crionuke.devstracker.server.exceptions.InternalServerException;
import com.crionuke.devstracker.server.services.actions.InsertAnonymousUser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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

    public void createAnonymousUser(String anonymousId)
            throws AnonymousUserAlreadyCreatedException, InternalServerException {
        try(Connection connection = dataSource.getConnection()) {
            InsertAnonymousUser insertAnonymousUser = new InsertAnonymousUser(connection, anonymousId);
        } catch (SQLException e) {
            throw new InternalServerException("Datasource unavailable, " + e.getMessage(), e);
        }
    }
}
