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

    // 1. Listar todas as provas do professor logado
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

    // 2. Buscar uma prova específica (com as questões)
    @GetMapping("/{id}")
    public ResponseEntity<ProvaDto> buscarPorId(@PathVariable Long id, Principal principal) {
        String login = principal.getName();
        Usuario professor = usuarioService.buscarPorLogin(login);

        Prova prova = provaService.buscarPorId(id);
        if (prova == null || !prova.getDisciplina().getProfessor().getId().equals(professor.getId())) {
            return ResponseEntity.status(403).build(); // Proibido se não for dono da prova
        }

        return ResponseEntity.ok(converterParaDTO(prova));
    }

    // 3. Listar alunos com status de correção da prova
    @GetMapping("/{provaId}/alunos-status")
    public ResponseEntity<List<AlunoStatusDTO>> listarStatusAlunosDaProva(
            @PathVariable Long provaId,
            Principal principal) {

        String login = principal.getName();
        Usuario professor = usuarioService.buscarPorLogin(login);

        Prova prova = provaService.buscarPorId(provaId);
        if (prova == null || !prova.getDisciplina().getProfessor().getId().equals(professor.getId())) {
            return ResponseEntity.status(403).build(); // Proibido
        }

        List<Aluno> alunosDaProva = provaService.buscarAlunosPorProva(provaId);
        List<RespostaAluno> respostas = respostaAlunoService.buscarPorProvaId(provaId);

        List<AlunoStatusDTO> statusAlunos = alunosDaProva.stream().map(aluno -> {
            boolean corrigido = respostas.stream().anyMatch(r -> r.getAluno().getId().equals(aluno.getId()));
            String status = corrigido ? "CORRIGIDO" : "PENDENTE";
            return new AlunoStatusDTO(aluno.getId(), aluno.getUsuario().getNome(), status);
        }).collect(Collectors.toList());

        return ResponseEntity.ok(statusAlunos);
    }

    // Converter Prova para DTO (com as questões)
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