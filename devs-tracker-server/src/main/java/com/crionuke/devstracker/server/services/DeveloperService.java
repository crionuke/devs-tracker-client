package com.crionuke.devstracker.server.services;

import com.crionuke.devstracker.core.actions.InsertDefaultChecks;
import com.crionuke.devstracker.core.actions.InsertDeveloper;
import com.crionuke.devstracker.core.actions.SelectDeveloper;
import com.crionuke.devstracker.core.actions.SelectDeveloperApps;
import com.crionuke.devstracker.core.api.apple.AppleApi;
import com.crionuke.devstracker.core.dto.Developer;
import com.crionuke.devstracker.core.dto.DeveloperApp;
import com.crionuke.devstracker.core.dto.SearchDeveloper;
import com.crionuke.devstracker.core.exceptions.DeveloperAlreadyAddedException;
import com.crionuke.devstracker.core.exceptions.DeveloperNotFoundException;
import com.crionuke.devstracker.core.exceptions.InternalServerException;
import com.crionuke.devstracker.server.exceptions.DeveloperNotCachedException;
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
    private final AppleApi appleApi;
    private final Map<Long, SearchDeveloper> searchCache;

    DeveloperService(DataSource dataSource, AppleApi appleApi) {
        this.dataSource = dataSource;
        this.appleApi = appleApi;
        searchCache = new ConcurrentHashMap<>();
    }

    public List<SearchDeveloper> search(List<String> countries, String term) {
        // TODO: Check arguments
        List<SearchDeveloper> developers = appleApi
                .searchDeveloper(countries, term)
                .flatMap(response -> Flux.fromIterable(response.getResults()))
                .map(result -> new SearchDeveloper(result.getArtistId(), result.getArtistName()))
                .distinct()
                .take(8)
                .collectList()
                .block();
        // Cache results
        developers.stream().forEach(searchDeveloper -> searchCache.put(searchDeveloper.getAppleId(), searchDeveloper));
        logger.debug("Got response from Apple SearchAPI, term={}, {}", term, developers);
        return developers;
    }

    public Developer selectOrAddDeveloperFromCache(Connection connection, long developerAppleId)
            throws DeveloperNotCachedException, InternalServerException {
        try {
            SelectDeveloper selectDeveloper = new SelectDeveloper(connection, developerAppleId);
            return selectDeveloper.getDeveloper();
        } catch (DeveloperNotFoundException e1) {
            SearchDeveloper searchDeveloper = searchCache.get(developerAppleId);
            if (searchDeveloper != null) {
                try {
                    InsertDeveloper insertDeveloper =
                            new InsertDeveloper(connection, searchDeveloper.getAppleId(), searchDeveloper.getName());
                    InsertDefaultChecks defaultChecks =
                            new InsertDefaultChecks(connection, insertDeveloper.getDeveloper().getId());
                    return insertDeveloper.getDeveloper();
                } catch (DeveloperAlreadyAddedException e2) {
                    try {
                        SelectDeveloper selectDeveloper = new SelectDeveloper(connection, developerAppleId);
                        return selectDeveloper.getDeveloper();
                    } catch (DeveloperNotFoundException e3) {
                        throw new InternalServerException("Wrong internal state around searchDeveloper, " +
                                "developerAppleId=" + developerAppleId);
                    }
                }
            } else {
                // TODO: search by apple server???
                throw new DeveloperNotCachedException("Developer not cached, try search again, " +
                        "developerAppleId=" + developerAppleId);
            }
        }
    }

    public List<DeveloperApp> getDeveloperApps(long developerAppleId) throws InternalServerException {
        try (Connection connection = dataSource.getConnection()) {
            try {
                SelectDeveloperApps selectDeveloperApps = new SelectDeveloperApps(connection, developerAppleId);
                return selectDeveloperApps.getDeveloperApps();
            } catch (InternalServerException e) {
                throw e;
            }
        } catch (SQLException e) {
            throw new InternalServerException("Datasource unavailable, " + e.getMessage(), e);
        }
    }
}
