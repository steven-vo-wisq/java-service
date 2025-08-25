package com.example.javaservice.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
@Tag(name = "Hello API", description = "Demo endpoints")
public class HelloController {

    @GetMapping("/hello")
    @Operation(summary = "Say hello", description = "Returns a greeting message")
    public String hello() {
        return "Hello from java-service!";
    }
}
