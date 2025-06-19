package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.model.FakeDatabase;
import com.example.corrige_gabarito.java.model.Matricula;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/matricula")
public class MatriculaController {

    @GetMapping("/form")
    public String formularioMatricula(
            @RequestParam(required = false) Long turmaSelecionada,
            @RequestParam(required = false) Long alunoSelecionado,
            @RequestParam(required = false) Long disciplinaSelecionada,
            Model model) {

        model.addAttribute("turmas", FakeDatabase.turmas);
        model.addAttribute("alunos", FakeDatabase.alunos);
        model.addAttribute("disciplinas", FakeDatabase.disciplinas);

        model.addAttribute("turmaSelecionada", turmaSelecionada);
        model.addAttribute("alunoSelecionado", alunoSelecionado);
        model.addAttribute("disciplinaSelecionada", disciplinaSelecionada);

        return "matricula/form";
    }

    @PostMapping("/salvar")
    public String salvarMatricula(@ModelAttribute Matricula matricula) {
        matricula.setId(FakeDatabase.matriculaIdCounter.getAndIncrement());
        FakeDatabase.matriculas.add(matricula);
        return "redirect:/matricula/form";
    }
}
