package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.model.Disciplina;
import com.example.corrige_gabarito.java.model.FakeDatabase;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/disciplinas")
public class DisciplinaController {

    @PostMapping("/salvar")
    public String salvarDisciplina(@ModelAttribute Disciplina disciplina) {
        disciplina.setId(FakeDatabase.disciplinaIdCounter.getAndIncrement());
        FakeDatabase.disciplinas.add(disciplina);
        return "redirect:/matricula/form?disciplinaSelecionada=" + disciplina.getId();
    }
}
