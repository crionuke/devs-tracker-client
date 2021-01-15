package com.crionuke.devstracker.robot;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableScheduling
@SpringBootApplication
@ComponentScan("com.crionuke.devstracker.robot")
@ComponentScan("com.crionuke.devstracker.core")
public class Robot {

    static {
        System.setProperty("spring.profiles.active", "robot");
    }

    public static void main(String[] args) {
        SpringApplication.run(Robot.class, args);
    }
}
