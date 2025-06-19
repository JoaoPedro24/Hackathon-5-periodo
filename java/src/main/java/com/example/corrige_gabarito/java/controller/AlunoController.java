package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.model.Aluno;
import com.example.corrige_gabarito.java.model.FakeDatabase;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/alunos")
public class AlunoController {

    @PostMapping("/salvar")
    public String salvarAluno(@ModelAttribute Aluno aluno) {
        aluno.setId(FakeDatabase.alunoIdCounter.getAndIncrement());
        FakeDatabase.alunos.add(aluno);
        return "redirect:/matricula/form?alunoSelecionado=" + aluno.getId();
    }
}
