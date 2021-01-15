package com.crionuke.devstracker.server;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan("com.crionuke.devstracker.server")
@ComponentScan("com.crionuke.devstracker.core")
public class Server {

    static {
        System.setProperty("spring.profiles.active", "server");
    }

    public static void main(String[] args) {
        SpringApplication.run(Server.class, args);
    }
}
