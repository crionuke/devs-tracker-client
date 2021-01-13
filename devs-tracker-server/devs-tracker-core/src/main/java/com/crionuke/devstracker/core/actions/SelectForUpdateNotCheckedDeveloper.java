package com.crionuke.devstracker.core.actions;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SelectForUpdateNotCheckedDeveloper {
    private static final Logger logger = LoggerFactory.getLogger(SelectForUpdateNotCheckedDeveloper.class);

    private final String SELECT_SQL = "SELECT FROM developers INNER JOIN checks ON c_developer_id = d_id WHERE d_apple_id = ?"
}
