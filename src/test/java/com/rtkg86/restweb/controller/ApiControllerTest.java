package com.rtkg86.restweb.controller;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.hamcrest.Matchers.*;

@WebMvcTest(ApiController.class)
public class ApiControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    public void testHelloEndpoint() throws Exception {
        mockMvc.perform(get("/api/hello"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message", equalTo("Hello from REST API")))
                .andExpect(jsonPath("$.status", equalTo("success")));
    }

    @Test
    public void testGreetEndpoint() throws Exception {
        mockMvc.perform(get("/api/greet/John"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message", equalTo("Hello, John!")))
                .andExpect(jsonPath("$.status", equalTo("success")));
    }

    @Test
    public void testHealthEndpoint() throws Exception {
        mockMvc.perform(get("/api/health"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status", equalTo("UP")));
    }

    @Test
    public void testEchoEndpoint() throws Exception {
        String requestBody = "{\"message\": \"test message\"}";

        mockMvc.perform(post("/api/echo")
                .contentType("application/json")
                .content(requestBody))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status", equalTo("success")))
                .andExpect(jsonPath("$.received.message", equalTo("test message")));
    }
}

