package com.crionuke.devstracker.robot;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan("com.crionuke.devstracke.core")
public class Robot {

    public static void main(String[] args) {
        SpringApplication.run(Robot.class, args);
    }
}
