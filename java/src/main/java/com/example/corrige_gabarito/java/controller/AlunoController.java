package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.dto.ProvaAluno;
import com.example.corrige_gabarito.java.model.*;
import com.example.corrige_gabarito.java.service.*;
import lombok.AllArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
@AllArgsConstructor
@RequestMapping("/aluno")
public class AlunoController {

    private final UsuarioService usuarioService;
    private final AlunoService alunoService;
    private final ProvaService provaService;
    private final RespostaAlunoService respostaAlunoService;
    private final PasswordEncoder passwordEncoder;

    @GetMapping("/listar")
    public String listar(Model model) {
        model.addAttribute("usuarios", alunoService.listarUsuariosNaoAssociados());
        model.addAttribute("alunos", alunoService.listarTodos());
        return "aluno/lista";
    }

    @PostMapping
    public String salvar(@ModelAttribute Aluno aluno, Model model) {
        return salvarOuAtualizar(aluno, model);
    }

    private String salvarOuAtualizar(Aluno aluno, Model model) {
        try {
            if (aluno.getUsuario() != null && aluno.getUsuario().getId() != null) {
                Usuario usuario = usuarioService.buscarPorId(aluno.getUsuario().getId());
                aluno.setUsuario(usuario);
            }

            if (aluno.getUsuario() != null && aluno.getUsuario().getId() != null) {
                Usuario usuario = usuarioService.buscarPorId(aluno.getUsuario().getId());
                aluno.setUsuario(usuario);
            }

            alunoService.salvar(aluno);
            return "redirect:/aluno/listar";

        } catch (Exception e) {
            model.addAttribute("message", "Não foi possível salvar o aluno: " + e.getMessage());
            model.addAttribute("alunos", alunoService.listarTodos());
            model.addAttribute("usuarios", alunoService.listarUsuariosNaoAssociados());
            return "aluno/lista";
        }
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model) {
        Aluno aluno = alunoService.buscarPorId(id);
        if (aluno != null) {
            model.addAttribute("aluno", aluno);
        } else {
            model.addAttribute("aluno", new Aluno());
            model.addAttribute("message", "Aluno não encontrado");
        }
        model.addAttribute("alunos", alunoService.listarTodos());
        model.addAttribute("usuarios", usuarioService.listarUsuariosPorRole("ALUNO"));
        return "aluno/lista";
    }

    @GetMapping("/remover/{id}")
    public String remover(@PathVariable Long id, Model model) {
        try {
            alunoService.deletarPorId(id);
        } catch (DataIntegrityViolationException e) {
            model.addAttribute("message", "Erro: Não é possível excluir o aluno, pois existem registros vinculados (respostas, turmas ou outras entidades).");
        } catch (EmptyResultDataAccessException e) {
            model.addAttribute("message", "Erro: Aluno com o ID informado não encontrado.");
        } catch (Exception e) {
            model.addAttribute("message", "Erro inesperado ao tentar excluir o aluno: " + e.getMessage());
        }

        model.addAttribute("alunos", alunoService.listarTodos());
        model.addAttribute("usuarios", alunoService.listarUsuariosNaoAssociados());
        return "aluno/lista";
    }


    @GetMapping("/minhas-provas")
    public String listarProvasDoAluno(
            @RequestParam(required = false) Long disciplinaId,
            Model model,
            Principal principal) {

        // Buscar o aluno logado
        Usuario usuario = usuarioService.buscarPorLogin(principal.getName());
        Aluno aluno = alunoService.buscarPorUsuario(usuario);

        // Buscar IDs das turmas do aluno
        Set<Long> idsTurmas = aluno.getTurmas().stream()
                .map(Turma::getId)
                .collect(Collectors.toSet());

        // Buscar todas as provas das turmas
        List<Prova> todasAsProvas = provaService.buscarPorTurmas(idsTurmas);

        // Buscar todas as disciplinas (antes de filtrar)
        Set<Disciplina> disciplinas = todasAsProvas.stream()
                .map(Prova::getDisciplina)
                .collect(Collectors.toSet());

        // Agora faz o filtro se o aluno escolheu uma disciplina
        List<Prova> provasFiltradas = todasAsProvas;
        if (disciplinaId != null) {
            provasFiltradas = todasAsProvas.stream()
                    .filter(p -> p.getDisciplina().getId().equals(disciplinaId))
                    .collect(Collectors.toList());
        }

        // Ordenar por data: mais recente primeiro
        provasFiltradas.sort((p1, p2) -> p2.getDataAplicacao().compareTo(p1.getDataAplicacao()));

        // Buscar respostas do aluno
        List<RespostaAluno> respostasDoAluno = respostaAlunoService.buscarPorAlunoId(aluno.getId());

        // Calcular notas por prova
        Map<Long, BigDecimal> notaPorProva = respostasDoAluno.stream()
                .collect(Collectors.groupingBy(
                        r -> r.getProva().getId(),
                        Collectors.mapping(RespostaAluno::getValor, Collectors.reducing(BigDecimal.ZERO, BigDecimal::add))
                ));

        List<ProvaAluno> provasComResultado = new ArrayList<>();
        for (Prova prova : provasFiltradas) {
            BigDecimal notaAluno = notaPorProva.getOrDefault(prova.getId(), null);
            BigDecimal notaMaxima = provaService.calcularNotaMaxima(prova.getId());

            ProvaAluno dto = new ProvaAluno();
            dto.setId(prova.getId());
            dto.setNome(prova.getNome());
            dto.setData(prova.getDataAplicacao());
            dto.setDisciplina(prova.getDisciplina());
            dto.setTurma(prova.getTurma());
            dto.setResultado(notaAluno != null ? notaAluno.doubleValue() : null);
            dto.setNotaMaxima(notaMaxima != null ? notaMaxima.doubleValue() : null);

            provasComResultado.add(dto);
        }

        model.addAttribute("disciplinas", disciplinas);
        model.addAttribute("disciplinaSelecionadaId", disciplinaId);
        model.addAttribute("provas", provasComResultado);

        return "aluno/provas";
    }
}
