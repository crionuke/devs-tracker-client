package com.crionuke.devstracker.server.services;

import com.crionuke.devstracker.server.services.api.AppleSearchApi;
import com.crionuke.devstracker.server.services.dto.SearchDeveloper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Flux;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class DeveloperService {
    private static final Logger logger = LoggerFactory.getLogger(DeveloperService.class);

    private final AppleSearchApi appleSearchApi;

    private final Map<Long, SearchDeveloper> searchCache;

    DeveloperService(AppleSearchApi appleSearchApi) {
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
        developers.stream().forEach(searchDeveloper -> searchCache.put(searchDeveloper.getAppleId(), searchDeveloper));
        logger.debug("Got response from Apple SearchAPI, term={}, {}", term, developers);
        return developers;
    }

    public Map<Long, SearchDeveloper> getSearchCache() {
        return searchCache;
    }
}
