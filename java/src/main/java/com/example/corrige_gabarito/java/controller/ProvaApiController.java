package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.api.dto.AlunoStatusDTO;
import com.example.corrige_gabarito.java.api.dto.ProvaDto;
import com.example.corrige_gabarito.java.api.dto.QuestaoComRespostaDTO;
import com.example.corrige_gabarito.java.model.*;
import com.example.corrige_gabarito.java.service.ProvaService;
import com.example.corrige_gabarito.java.service.QuestaoService;
import com.example.corrige_gabarito.java.service.RespostaAlunoService;
import com.example.corrige_gabarito.java.service.UsuarioService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.security.Principal;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/provas")
@RequiredArgsConstructor
public class ProvaApiController {

    private final ProvaService provaService;
    private final UsuarioService usuarioService;
    private final RespostaAlunoService respostaAlunoService;
    private final QuestaoService questaoService;

    // Listar todas as provas do professor logado
    @GetMapping
    public ResponseEntity<List<ProvaDto>> listarMinhasProvas(Principal principal) {
        String login = principal.getName();
        Usuario professor = usuarioService.buscarPorLogin(login);

        List<Prova> provas = provaService.listarPorProfessorId(professor.getId());
        List<ProvaDto> dtos = provas.stream()
                .map(this::converterParaDTO)
                .collect(Collectors.toList());

        return ResponseEntity.ok(dtos);
    }

    // Listar alunos com status de correção da prova
    @GetMapping("/{provaId}/alunos-status")
    public ResponseEntity<List<AlunoStatusDTO>> listarStatusAlunosDaProva(
            @PathVariable Long provaId,
            Principal principal) {

        String login = principal.getName();
        Usuario professor = usuarioService.buscarPorLogin(login);

        Prova prova = provaService.buscarPorId(provaId);
        if (prova == null || !prova.getDisciplina().getProfessor().getId().equals(professor.getId())) {
            return ResponseEntity.status(403).build();
        }

        List<Aluno> alunosDaProva = provaService.buscarAlunosPorProva(provaId);
        List<RespostaAluno> respostas = respostaAlunoService.buscarPorProvaId(provaId);

        List<AlunoStatusDTO> statusAlunos = alunosDaProva.stream().map(aluno -> {
            List<RespostaAluno> respostasDoAluno = respostas.stream()
                    .filter(r -> r.getAluno().getId().equals(aluno.getId()))
                    .collect(Collectors.toList());

            boolean corrigido = !respostasDoAluno.isEmpty();
            String status = corrigido ? "CORRIGIDO" : "PENDENTE";

            BigDecimal nota = corrigido
                    ? respostasDoAluno.stream()
                    .map(RespostaAluno::getValor)
                    .reduce(BigDecimal.ZERO, BigDecimal::add)
                    : BigDecimal.ZERO;

            int acertos = (int) respostasDoAluno.stream()
                    .filter(r -> r.getValor().compareTo(BigDecimal.ZERO) > 0)
                    .count();

            return new AlunoStatusDTO(
                    aluno.getId(),
                    aluno.getUsuario().getNome(),
                    status,
                    aluno.getMatricula(),
                    nota,
                    acertos
            );
        }).collect(Collectors.toList());

        return ResponseEntity.ok(statusAlunos);
    }

    // Converter Prova para DTO
    private ProvaDto converterParaDTO(Prova prova) {
        List<Aluno> alunosDaProva = provaService.buscarAlunosPorProva(prova.getId());
        int totalAlunos = alunosDaProva.size();

        List<RespostaAluno> respostas = respostaAlunoService.buscarPorProvaId(prova.getId());
        long totalCorrigidos = respostas.stream()
                .map(r -> r.getAluno().getId())
                .distinct()
                .count();

        return ProvaDto.builder()
                .id(prova.getId())
                .nome(prova.getNome())
                .valorTotal(prova.getValorTotal())
                .disciplina(prova.getDisciplina() != null ? prova.getDisciplina().getNome() : null)
                .turma(prova.getTurma() != null ? prova.getTurma().getNome() : null)
                .totalAlunos(totalAlunos)
                .totalAlunosCorrigidos((int) totalCorrigidos)
                .build();
    }

    @GetMapping("/{provaId}/questoes")
    public ResponseEntity<List<QuestaoComRespostaDTO>> listarQuestoesDaProvaComRespostasDoAluno(
            @PathVariable Long provaId,
            Principal principal) {

        String login = principal.getName();
        Usuario professor = usuarioService.buscarPorLogin(login);

        Prova prova = provaService.buscarPorId(provaId);

        List<QuestaoComRespostaDTO> questoesComRespostas = questaoService.listarQuestoesComRespostasDoAluno(provaId);

        return ResponseEntity.ok(questoesComRespostas);
    }
}