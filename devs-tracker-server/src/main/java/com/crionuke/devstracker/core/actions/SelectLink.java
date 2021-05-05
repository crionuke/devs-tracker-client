package com.crionuke.devstracker.core.actions;

import com.crionuke.devstracker.core.dto.Link;
import com.crionuke.devstracker.core.exceptions.InternalServerException;
import com.crionuke.devstracker.core.exceptions.LinkNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;

public class SelectLink {
    private static final Logger logger = LoggerFactory.getLogger(SelectLink.class);

    private final String SELECT_SQL = "SELECT l_id, l_added, l_title, l_url FROM links " +
            "WHERE l_app_id = ? AND l_country = ?";

    private final Link link;

    public SelectLink(Connection connection, long appId, String country)
            throws LinkNotFoundException, InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(SELECT_SQL)) {
            statement.setLong(1, appId);
            statement.setString(2, country);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    long id = resultSet.getLong(1);
                    Timestamp added = resultSet.getTimestamp(2);
                    String title = resultSet.getString(3);
                    String url = resultSet.getString(4);
                    link = new Link(id, added, appId, title, country, url);
                    logger.trace("Link selected, {}", link);
                } else {
                    throw new LinkNotFoundException("Link not found, " + "appId=" + appId + ", country=" + country);
                }
            }
        } catch (SQLException e) {
            throw new InternalServerException("Transaction failed, " + e.getMessage(), e);
        }
    }

    public Link getLink() {
        return link;
    }
}
