package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.model.Aluno;
import com.example.corrige_gabarito.java.model.Disciplina;
import com.example.corrige_gabarito.java.model.Usuario;
import com.example.corrige_gabarito.java.service.DisciplinaService;
import com.example.corrige_gabarito.java.service.ProfessorService;
import com.example.corrige_gabarito.java.service.UsuarioService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@AllArgsConstructor
@RequestMapping("/disciplina")
public class DisciplinaController {

    private final DisciplinaService disciplinaService;
    private final UsuarioService usuarioService;

    @GetMapping("/listar")
    public String listar(Model model) {
        model.addAttribute("disciplinas", disciplinaService.listarTodos());
        model.addAttribute("professores", usuarioService.listarUsuariosPorRole("PROFESSOR"));
        return "disciplina/lista";
    }

    @PostMapping
    public String salvar(@ModelAttribute Disciplina disciplina, Model model) {
        return salvarOuAtualizar(disciplina, model);
    }

    private String salvarOuAtualizar(Disciplina disciplina, Model model) {
        try {
            if (disciplina.getProfessor() == null || disciplina.getProfessor().getId() == null) {
                throw new IllegalArgumentException("Professor não selecionado");
            }
            
            Usuario professor = usuarioService.buscarPorId(disciplina.getProfessor().getId());
            if (professor == null) {
                throw new IllegalArgumentException("Professor não encontrado com o ID: " + disciplina.getProfessor().getId());
            }
            
            disciplina.setProfessor(professor);
            disciplinaService.salvar(disciplina);
            return "redirect:/disciplina/listar";
        } catch (Exception e) {
            String errorMessage = "Erro ao salvar disciplina: " + e.getMessage();
            model.addAttribute("message", errorMessage);
            model.addAttribute("professores", usuarioService.listarUsuariosPorRole("PROFESSOR"));
            model.addAttribute("disciplina", disciplina);  // Keep the form data on error
            return "disciplina/lista";
        }
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model) {
        Disciplina disciplina = disciplinaService.buscarPorId(id);
        if (disciplina != null) {
            model.addAttribute("disciplina", disciplina);
        } else {
            model.addAttribute("disciplina", new Disciplina());
            model.addAttribute("message", "Disciplina não encontrado");
        }
        model.addAttribute("professores", usuarioService.listarUsuariosPorRole("PROFESSOR"));
        model.addAttribute("disciplinas", disciplinaService.listarTodos());
        return "disciplina/lista";
    }

    @GetMapping("/remover/{id}")
    public String remover(@PathVariable Long id) {
        disciplinaService.deletarPorId(id);
        return "redirect:/disciplina/listar";
    }
}
