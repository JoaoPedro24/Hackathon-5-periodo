package com.example.corrige_gabarito.java.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home() {
        return "index";  // O Spring vai buscar o arquivo /src/main/resources/templates/index.html
    }
}
