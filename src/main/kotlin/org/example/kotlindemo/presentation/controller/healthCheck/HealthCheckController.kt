package org.example.kotlindemo.presentation.controller.healthCheck

import org.example.kotlindemo.presentation.response.healthCheck.HealthCheckRes
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class HealthCheckController {
    @GetMapping("/api/health-check")
    fun healthCheck(): HealthCheckRes {
        return HealthCheckRes("ok")
    }
}