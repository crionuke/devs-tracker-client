package com.crionuke.devstracker.server.controllers.dto;

import java.util.Objects;

public class SearchDeveloper {

    private final long id;
    private final String name;

    public SearchDeveloper(long id, String name) {
        this.id = id;
        this.name = name;
    }

    public long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        SearchDeveloper that = (SearchDeveloper) o;
        return id == that.id &&
                name.equals(that.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, name);
    }
}
