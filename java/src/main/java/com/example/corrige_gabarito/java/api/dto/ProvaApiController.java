package com.example.corrige_gabarito.java.api.dto;

import com.example.corrige_gabarito.java.model.Prova;
import com.example.corrige_gabarito.java.model.Questao;
import com.example.corrige_gabarito.java.service.ProvaService;
import com.example.corrige_gabarito.java.service.UsuarioService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@AllArgsConstructor
@RequestMapping("/api/provas")
public class    ProvaApiController {

    private final ProvaService provaService;
    private final UsuarioService usuarioService;

    @GetMapping
    public ResponseEntity<List<ProvaDto>> listarTodas() {
        List<Prova> provas = provaService.listarTodas();
        List<ProvaDto> dtos = provas.stream()
                .map(this::converterParaDTO)
                .collect(Collectors.toList());

        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProvaDto> buscarPorId(@PathVariable Long id) {
        Prova prova = provaService.buscarPorId(id);
        if (prova == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(converterParaDTO(prova));
    }

    @GetMapping("/professor/{professorId}")
    public ResponseEntity<List<ProvaDto>> listarPorProfessor(@PathVariable Long professorId) {
        List<Prova> provas = provaService.listarPorProfessorId(professorId);

        List<ProvaDto> dtos = provas.stream()
                .map(this::converterParaDTO)
                .collect(Collectors.toList());

        return ResponseEntity.ok(dtos);
    }

    private ProvaDto converterParaDTO(Prova prova) {
        return ProvaDto.builder()
                .id(prova.getId())
                .nome(prova.getNome())
                .valorTotal(prova.getValorTotal())
                .disciplina(prova.getDisciplina() != null ? prova.getDisciplina().getNome() : null)
                .turma(prova.getTurma() != null ? prova.getTurma().getNome() : null)
                .questoes(prova.getQuestoes().stream()
                        .map(this::converterQuestaoParaDTO)
                        .collect(Collectors.toList()))
                .build();
    }

    private ProvaDto.QuestaoDTO converterQuestaoParaDTO(Questao questao) {
        return ProvaDto.QuestaoDTO.builder()
                .id(questao.getId())
                .tipo(questao.getTipo().name())
                .valor(questao.getValor())
                .enunciado(questao.getEnunciado())
                .respostaCorreta(questao.getRespostaCorreta())
                .build();
    }
}
