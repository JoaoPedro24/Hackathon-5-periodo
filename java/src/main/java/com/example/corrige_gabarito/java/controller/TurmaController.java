package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.model.Aluno;
import com.example.corrige_gabarito.java.model.Turma;
import com.example.corrige_gabarito.java.model.Usuario;
import com.example.corrige_gabarito.java.service.AlunoService;
import com.example.corrige_gabarito.java.service.TurmaService;
import com.example.corrige_gabarito.java.service.UsuarioService;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Controller
@RequiredArgsConstructor
@RequestMapping("/turma")
public class TurmaController {

    private final TurmaService turmaService;
    private final AlunoService alunoService;

    @GetMapping("/listar")
    public String listarTurmas(Model model, @RequestParam Optional<Long> turmaId) {
        model.addAttribute("turmas", turmaService.listarTodas());
        List<Aluno> alunos = alunoService.listarTodos();
        model.addAttribute("alunos", alunos);
        model.addAttribute("turma", new Turma());

        return "turma/lista";
    }

    @GetMapping("/editar/{id}")
    public String editarTurma(@PathVariable Long id, Model model) {
        Turma turma = turmaService.buscarPorId(id);
        if (turma != null) {
            model.addAttribute("turma", turma);
        } else {
            model.addAttribute("turma", new Turma());
            model.addAttribute("message", "Aluno não encontrado");
        }
        model.addAttribute("turmas", turmaService.listarTodas());
        List<Aluno> alunos = alunoService.listarTodos();
        model.addAttribute("alunos", alunos);
        return "turma/lista";
    }


    @PostMapping
    public String salvar(
            @ModelAttribute Turma turma,
            @RequestParam(value = "alunosIds", required = false) List<Long> alunosIds
    ) {
        if (alunosIds == null) {
            alunosIds = Collections.emptyList();
        }
        turmaService.salvarTurmaComAlunos(turma, alunosIds);
        return "redirect:/turma/listar";
    }

    @GetMapping("/remover/{id}")
    public String remover(@PathVariable Long id, Model model) {
        try {
            turmaService.deletarTurma(id);
        } catch (DataIntegrityViolationException e) {
            model.addAttribute("message", "Erro: Não é possível excluir essa turma, pois existem registros vinculados (alunos, disciplinas ou professores).");
        } catch (EmptyResultDataAccessException e) {
            model.addAttribute("message", "Erro: Turma com o ID informado não encontrado.");
        } catch (Exception e) {
            model.addAttribute("message", "Erro inesperado ao tentar excluir a turma: " + e.getMessage());
        }

        model.addAttribute("turma", turmaService.listarTodas());
        return "redirect:/turma/listar";
    }

}
