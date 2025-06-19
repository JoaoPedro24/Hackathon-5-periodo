package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.model.FakeDatabase;
import com.example.corrige_gabarito.java.model.Turma;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/turmas")
public class TurmaController {

    @PostMapping("/salvar")
    public String salvarTurma(@ModelAttribute Turma turma) {
        turma.setId(FakeDatabase.turmaIdCounter.getAndIncrement());
        FakeDatabase.turmas.add(turma);
        return "redirect:/matricula/form?turmaSelecionada=" + turma.getId();
    }
}
