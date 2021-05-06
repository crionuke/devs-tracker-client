package com.crionuke.devstracker.actions;

import com.crionuke.devstracker.exceptions.InternalServerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SelectAppLinks {
    private static final Logger logger = LoggerFactory.getLogger(SelectAppLinks.class);

    private final String SELECT_SQL = "SELECT l_country FROM links WHERE l_app_id = ?";

    private final List<String> countries;

    public SelectAppLinks(Connection connection, long appId) throws InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(SELECT_SQL)) {
            statement.setLong(1, appId);
            try (ResultSet resultSet = statement.executeQuery()) {
                countries = new ArrayList<>();
                while (resultSet.next()) {
                    String country = resultSet.getString(1);
                    countries.add(country);
                }
            }
        } catch (SQLException e) {
            throw new InternalServerException("Transaction failed, " + e.getMessage(), e);
        }
    }

    public List<String> getCountries() {
        return countries;
    }
}
