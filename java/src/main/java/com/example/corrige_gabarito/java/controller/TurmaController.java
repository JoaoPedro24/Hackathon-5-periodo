package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.model.Aluno;
import com.example.corrige_gabarito.java.model.Turma;
import com.example.corrige_gabarito.java.model.Usuario;
import com.example.corrige_gabarito.java.service.AlunoService;
import com.example.corrige_gabarito.java.service.TurmaService;
import com.example.corrige_gabarito.java.service.UsuarioService;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
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

    /**
     * Lista todas as turmas
     */
    @GetMapping("/listar")
    public String listarTurmas(Model model, @RequestParam Optional<Long> turmaId) {
        model.addAttribute("turmas", turmaService.listarTodas());
        List<Aluno> alunos = alunoService.listarTodos();
        model.addAttribute("alunos", alunos);
        model.addAttribute("turma", new Turma());

        return "turma/lista";
    }


    /**
     * Abre o modal para edição (chamado pelo botão Editar)
     */
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
        return "redirect:/turma/listar"; // redireciona para lista de turmas ou outra página
    }

    /**
     * Remover um aluno de uma turma
     */
    @PostMapping("/{turmaId}/aluno/{alunoId}/remover")
    public String removerAluno(@PathVariable Long turmaId, @PathVariable Long alunoId, RedirectAttributes redirectAttributes) {
        try {
            turmaService.removerAluno(turmaId, alunoId);
            redirectAttributes.addFlashAttribute("message", "Aluno removido com sucesso!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("message", "Erro ao remover aluno: " + e.getMessage());
        }
        redirectAttributes.addAttribute("turmaId", turmaId);
        return "redirect:/turma/listar";
    }
}
