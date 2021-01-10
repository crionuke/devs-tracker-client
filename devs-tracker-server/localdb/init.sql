CREATE TABLE IF NOT EXISTS users (
    u_id BIGSERIAL PRIMARY KEY,
    u_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    u_token VARCHAR(128) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS trackers (
    t_id BIGSERIAL PRIMARY KEY,
    t_added TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    t_user_id BIGINT NOT NULL,
    t_developer_id BIGINT NOT NULL,
    UNIQUE(t_user_id, t_developer_id)
);

CREATE TABLE IF NOT EXISTS developers (
    d_id BIGSERIAL PRIMARY KEY,
    d_added TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    d_apple_id BIGINT UNIQUE NOT NULL,
    d_name VARCHAR(128) NOT NULL
);

CREATE TABLE IF NOT EXISTS apps (
    a_id BIGSERIAL PRIMARY KEY,
    a_added TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    a_apple_id BIGINT UNIQUE NOT NULL,
    a_title VARCHAR(128) NOT NULL,
    a_developer_id BIGINT NOT NULL
);
