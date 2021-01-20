CREATE SCHEMA IF NOT EXISTS AUTHORIZATION devstracker;

CREATE TABLE IF NOT EXISTS devstracker.users (
    u_id BIGSERIAL PRIMARY KEY,
    u_added TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    u_token VARCHAR(128) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS devstracker.trackers (
    t_id BIGSERIAL PRIMARY KEY,
    t_added TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    t_user_id BIGINT NOT NULL,
    t_developer_id BIGINT NOT NULL,
    UNIQUE(t_user_id, t_developer_id)
);

CREATE TABLE IF NOT EXISTS devstracker.developers (
    d_id BIGSERIAL PRIMARY KEY,
    d_added TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    d_apple_id BIGINT UNIQUE NOT NULL,
    d_name VARCHAR(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS devstracker.checks (
    c_id BIGSERIAL PRIMARY KEY,
    c_added TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    c_developer_id BIGINT NOT NULL,
    c_country VARCHAR(2) NOT NULL,
    c_priority SMALLINT NOT NULL,
    c_last_check TIMESTAMP NOT NULL DEFAULT TIMESTAMP 'epoch',
    UNIQUE(c_developer_id, c_country)
);

CREATE TABLE IF NOT EXISTS devstracker.apps (
    a_id BIGSERIAL PRIMARY KEY,
    a_added TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    a_apple_id BIGINT UNIQUE NOT NULL,
    a_release_date TIMESTAMP  NOT NULL,
    a_title VARCHAR(128) NOT NULL,
    a_developer_id BIGINT NOT NULL
);

CREATE TABLE IF NOT EXISTS devstracker.links (
    l_id BIGSERIAL PRIMARY KEY,
    l_added TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    l_app_id BIGINT NOT NULL,
    l_country VARCHAR(2) NOT NULL,
    UNIQUE(l_app_id, l_country)
);
