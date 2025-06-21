package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.model.Disciplina;
import com.example.corrige_gabarito.java.model.Professor;
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
    private final ProfessorService professorService;

    @GetMapping("/listar")
    public String listar(Model model) {
        List<Disciplina> disciplinas = disciplinaService.listarTodos();
        model.addAttribute("disciplinas", disciplinas);
        model.addAttribute("disciplina", new Disciplina());
        model.addAttribute("professores", usuarioService.listarUsuariosPorRole("PROFESSOR"));
        return "disciplina/lista";
    }

    @PostMapping
    public String salvar(@ModelAttribute Disciplina disciplina, Model model) {
        return salvarOuAtualizar(disciplina, model);
    }

    private String salvarOuAtualizar(Disciplina disciplina, Model model) {
        try {
            Professor professor = professorService.buscarPorId(disciplina.getProfessor().getId());
            disciplina.setProfessor(professor);

            disciplinaService.salvar(disciplina);
            return "redirect:/disciplina/listar";
        } catch (Exception e) {
            model.addAttribute("message", "Erro ao salvar disciplina: " + e.getMessage());
            model.addAttribute("professores", usuarioService.listarUsuariosPorRole("PROFESSOR"));
            return "disciplina/lista";
        }
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model) {
        Disciplina disciplina = disciplinaService.buscarPorId(id);
        model.addAttribute("disciplina", disciplina);
        return "disciplina/formulario";
    }

    @GetMapping("/remover/{id}")
    public String remover(@PathVariable Long id) {
        disciplinaService.deletarPorId(id);
        return "redirect:/disciplina/listar";
    }
}
