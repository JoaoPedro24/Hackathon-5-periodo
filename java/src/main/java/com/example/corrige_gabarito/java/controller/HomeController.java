package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.model.*;
import com.example.corrige_gabarito.java.service.*;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
@AllArgsConstructor
public class HomeController {

    private final TurmaService turmaService;
    private final DisciplinaService disciplinaService;
    private final AlunoService alunoService;
    private final ProvaService provaService;
    private final UsuarioService professorService;

    @GetMapping("/")
    public String home(Model model) {

        List<Turma> turmas = turmaService.listarTodas();
        List<Disciplina> disciplinas = disciplinaService.listarTodos();
        List<Aluno> alunos = alunoService.listarTodos();
        List<Prova> provas = provaService.listarTodas();
        List<Usuario> professores = professorService.listarUsuariosPorRole("PROFESSOR");

        model.addAttribute("turmas", turmas);
        model.addAttribute("disciplinas", disciplinas);
        model.addAttribute("alunos", alunos);
        model.addAttribute("provas", provas);
        model.addAttribute("professores", professores);

        return "index";
    }
}
