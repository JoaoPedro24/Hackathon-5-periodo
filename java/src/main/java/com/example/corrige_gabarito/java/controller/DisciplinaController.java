package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.model.Disciplina;
import com.example.corrige_gabarito.java.service.DisciplinaService;
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

    @GetMapping
    public String form(Disciplina disciplina) {
        return "disciplina/formulario";
    }

    @GetMapping("/listar")
    public String listar(Model model) {
        List<Disciplina> disciplinas = disciplinaService.listarTodos();
        model.addAttribute("disciplinas", disciplinas);
        return "disciplina/lista";
    }

    @PostMapping
    public String salvar(Disciplina disciplina) {
        disciplinaService.salvar(disciplina);
        return "redirect:/disciplina/listar";
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
