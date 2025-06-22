package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.api.dto.CorrecaoProvaAlunoRequest;
import com.example.corrige_gabarito.java.api.dto.CorrecaoProvaResponse;
import com.example.corrige_gabarito.java.service.CorrecaoService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/correcao")
@RequiredArgsConstructor
public class CorrecaoController {

    private final CorrecaoService correcaoService;

    @PostMapping("/aluno")
    public CorrecaoProvaResponse corrigirProvaAluno(@RequestBody CorrecaoProvaAlunoRequest request) {
        return correcaoService.corrigirProvaAluno(request);
    }
}
