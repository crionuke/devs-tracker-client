package com.crionuke.devstracker.server.services;

import com.crionuke.devstracker.server.api.AppleSearchApi;
import com.crionuke.devstracker.server.controllers.dto.SearchDeveloper;
import com.crionuke.devstracker.server.exceptions.AnonymousUserNotFoundException;
import com.crionuke.devstracker.server.exceptions.DeveloperAlreadyAddedException;
import com.crionuke.devstracker.server.exceptions.DeveloperNotFoundException;
import com.crionuke.devstracker.server.exceptions.InternalServerException;
import com.crionuke.devstracker.server.services.actions.InsertDeveloper;
import com.crionuke.devstracker.server.services.actions.SelectAnonymousUser;
import com.crionuke.devstracker.server.services.actions.SelectDeveloper;
import com.crionuke.devstracker.server.services.dto.Developer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Flux;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class DeveloperService {
    private static final Logger logger = LoggerFactory.getLogger(DeveloperService.class);

    private final DataSource dataSource;
    private final AppleSearchApi appleSearchApi;

    private final Map<Long, SearchDeveloper> searchCache;

    DeveloperService(DataSource dataSource, AppleSearchApi appleSearchApi) {
        this.dataSource = dataSource;
        this.appleSearchApi = appleSearchApi;
        searchCache = new ConcurrentHashMap<>();
    }

    public List<SearchDeveloper> search(List<String> countries, String term) {
        // TODO: Check arguments
        List<SearchDeveloper> developers = appleSearchApi
                .searchDeveloper(countries, term)
                .flatMap(response -> Flux.fromIterable(response.getResults()))
                .map(result -> new SearchDeveloper(result.getArtistId(), result.getArtistName()))
                .distinct()
                .take(8)
                .collectList()
                .block();
        // Cache results
        developers.stream().forEach(developer -> searchCache.put(developer.getId(), developer));
        return developers;
    }

    public void track(String anonymousId, long developerAppleId) throws
            AnonymousUserNotFoundException, InternalServerException {
        // TODO: Check arguments
        try (Connection connection = dataSource.getConnection()) {
            SelectAnonymousUser selectAnonymousUser = new SelectAnonymousUser(connection, anonymousId);
            Developer developer;
            try {
                SelectDeveloper selectDeveloper = new SelectDeveloper(connection, developerAppleId);
                developer = selectDeveloper.getDeveloper();
            } catch (DeveloperNotFoundException e1) {
                SearchDeveloper searchDeveloper = searchCache.get(developerAppleId);
                if (searchDeveloper != null) {
                    try {
                        InsertDeveloper insertDeveloper = new InsertDeveloper(connection,
                                searchDeveloper.getId(), searchDeveloper.getName());
                        developer = insertDeveloper.getDeveloper();
                    } catch (DeveloperAlreadyAddedException e2) {
                        try {
                            SelectDeveloper selectDeveloper = new SelectDeveloper(connection, developerAppleId);
                            developer = selectDeveloper.getDeveloper();
                        } catch (DeveloperNotFoundException e3) {
                            throw new InternalServerException("Wrong internal state around developer, " +
                                    "developerAppleId=" + developerAppleId);
                        }
                    }
                } else {
                    // TODO: search by apple api???
                    throw new InternalServerException("Developer not cached, try search again, " +
                            "developerAppleId=" + developerAppleId);
                }
            }
        } catch (SQLException e) {
            throw new InternalServerException("Datasource unavailable, " + e.getMessage(), e);
        }
    }

    // TODO: schedule cache cleanup procecure
}
