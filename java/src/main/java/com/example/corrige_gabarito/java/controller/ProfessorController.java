package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.model.Professor;
import com.example.corrige_gabarito.java.service.ProfessorService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@AllArgsConstructor
@RequestMapping("/professor")
public class ProfessorController {

    private final ProfessorService professorService;

    @GetMapping
    public String form(Professor professor) {
        return "professor/formulario";
    }

    @GetMapping("/listar")
    public String listar(Model model) {
        List<Professor> professores = professorService.listarTodos();
        model.addAttribute("professores", professores);
        return "professor/lista";
    }

    @PostMapping
    public String salvar(Professor professor) {
        professorService.salvar(professor);
        return "redirect:/professor/listar";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model) {
        Professor professor = professorService.buscarPorId(id);
        model.addAttribute("professor", professor);
        return "professor/formulario";
    }

    @GetMapping("/remover/{id}")
    public String remover(@PathVariable Long id) {
        professorService.deletarPorId(id);
        return "redirect:/professor/listar";
    }
}
