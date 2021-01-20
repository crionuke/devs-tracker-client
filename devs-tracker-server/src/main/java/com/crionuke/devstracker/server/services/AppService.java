package com.crionuke.devstracker.server.services;

import com.crionuke.devstracker.core.actions.SelectApp;
import com.crionuke.devstracker.core.actions.SelectAppLinks;
import com.crionuke.devstracker.core.exceptions.AppNotFoundException;
import com.crionuke.devstracker.core.exceptions.InternalServerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

@Component
public class AppService {
    private static final Logger logger = LoggerFactory.getLogger(AppService.class);

    private final DataSource dataSource;

    AppService(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public List<String> getCountries(long appAppleId) throws AppNotFoundException, InternalServerException {
        try (Connection connection = dataSource.getConnection()) {
            SelectApp selectApp = new SelectApp(connection, appAppleId);
            SelectAppLinks selectAppLinks = new SelectAppLinks(connection, selectApp.getApp().getId());
            return selectAppLinks.getCountries();
        } catch (SQLException e) {
            throw new InternalServerException("Datasource unavailable, " + e.getMessage(), e);
        }
    }
}
