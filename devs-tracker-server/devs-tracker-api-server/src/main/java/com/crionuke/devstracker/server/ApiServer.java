package com.crionuke.devstracker.server;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan("com.crionuke.devstracke.core")
public class ApiServer {

    public static void main(String[] args) {
        SpringApplication.run(ApiServer.class, args);
    }
}
