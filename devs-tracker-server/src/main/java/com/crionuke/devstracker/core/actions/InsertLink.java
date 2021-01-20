package com.crionuke.devstracker.core.actions;

import com.crionuke.devstracker.core.dto.Link;
import com.crionuke.devstracker.core.exceptions.AppAlreadyAddedException;
import com.crionuke.devstracker.core.exceptions.InternalServerException;
import com.crionuke.devstracker.core.exceptions.LinkAlreadyAddedException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;

public class InsertLink {
    private static final Logger logger = LoggerFactory.getLogger(InsertLink.class);

    private final String INSERT_SQL = "INSERT INTO links (l_app_id, l_country) VALUES(?, ?)";

    private final Link link;

    public InsertLink(Connection connection, long appId, String country)
            throws LinkAlreadyAddedException, InternalServerException {
        try (PreparedStatement statement = connection.prepareStatement(INSERT_SQL,
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            statement.setLong(1, appId);
            statement.setString(2, country);
            statement.execute();
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    long id = generatedKeys.getLong("l_id");
                    Timestamp added = generatedKeys.getTimestamp("l_added");
                    link = new Link(id, added, appId, country);
                    logger.info("Link added, {}", link);
                } else {
                    throw new InternalServerException("Generated key not found");
                }
            }
        } catch (SQLException e) {
            if (e.getSQLState().equals("23505")) {
                throw new LinkAlreadyAddedException("Link already added, appId=" + appId + ", country=" + country, e);
            } else {
                throw new InternalServerException("Transaction failed, " + e.getMessage(), e);
            }
        }
    }

    public Link getLink() {
        return link;
    }
}
