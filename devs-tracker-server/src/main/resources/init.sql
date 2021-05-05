CREATE SCHEMA IF NOT EXISTS AUTHORIZATION devstracker;

CREATE TABLE IF NOT EXISTS devstracker.users (
    u_id BIGSERIAL PRIMARY KEY,
    u_added TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    u_token VARCHAR(128) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS devstracker.trackers (
    t_id BIGSERIAL PRIMARY KEY,s
    t_added TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    t_user_id BIGINT NOT NULL,
    t_developer_id BIGINT NOT NULL,
    t_last_view TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(t_user_id, t_developer_id)
);

CREATE TABLE IF NOT EXISTS devstracker.developers (
    d_id BIGSERIAL PRIMARY KEY,
    d_added TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    d_apple_id BIGINT UNIQUE NOT NULL,
    d_name VARCHAR(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS devstracker.checks (
    c_id BIGSERIAL PRIMARY KEY,
    c_added TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    c_developer_id BIGINT NOT NULL,
    c_country VARCHAR(2) NOT NULL,
    c_priority SMALLINT NOT NULL,
    c_last_check TIMESTAMPTZ NOT NULL DEFAULT TIMESTAMPTZ 'epoch',
    UNIQUE(c_developer_id, c_country)
);

CREATE TABLE IF NOT EXISTS devstracker.apps (
    a_id BIGSERIAL PRIMARY KEY,
    a_added TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    a_apple_id BIGINT UNIQUE NOT NULL,
    a_release_date TIMESTAMPTZ NOT NULL,
    a_developer_id BIGINT NOT NULL
);

CREATE TABLE IF NOT EXISTS devstracker.links (
    l_id BIGSERIAL PRIMARY KEY,
    l_added TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    l_app_id BIGINT NOT NULL,
    l_title VARCHAR(128) NOT NULL,
    l_country VARCHAR(2) NOT NULL,
    l_url VARCHAR (512) NOT NULL,
    UNIQUE(l_app_id, l_country)
);

CREATE TABLE IF NOT EXISTS devstracker.notifications (
    n_id BIGSERIAL PRIMARY KEY,
    n_added TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    n_app_id BIGINT UNIQUE NOT NULL,
    n_processed BOOLEAN NOT NULL DEFAULT FALSE,
    n_updated TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);