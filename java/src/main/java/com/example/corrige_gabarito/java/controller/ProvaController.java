package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.model.*;
import com.example.corrige_gabarito.java.service.*;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@Controller
@AllArgsConstructor
@RequestMapping("/prova")
public class ProvaController {

    private final ProvaService provaService;
    private final DisciplinaService disciplinaService;
    private final UsuarioService usuarioService;
    private final TurmaService turmaService;

    @GetMapping("/listar")
    public String listar(Model model, Principal principal) {
        Usuario professor = usuarioService.buscarPorLogin(principal.getName());
        List<Disciplina> disciplinasDoProfessor = disciplinaService.listarPorProfessor(professor);

        model.addAttribute("provas", provaService.listarTodas());
        model.addAttribute("prova", new Prova());
        model.addAttribute("disciplinas", disciplinasDoProfessor);
        model.addAttribute("turmas", turmaService.listarTodas());

        return "prova/lista";
    }

    @PostMapping
    public String salvar(@ModelAttribute Prova prova, Principal principal) {
        Usuario professor = usuarioService.buscarPorLogin(principal.getName());
        prova.setProfessor(professor);

        // Vincula as questões à prova
        if (prova.getQuestoes() != null) {
            for (Questao questao : prova.getQuestoes()) {
                questao.setProva(prova);
            }
        }

        provaService.salvar(prova);
        return "redirect:/prova/listar";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model, Principal principal) {
        Usuario professor = usuarioService.buscarPorLogin(principal.getName());
        Prova prova = provaService.buscarPorId(id);
        if (prova == null) {
            return "redirect:/prova/listar";
        }

        List<Disciplina> disciplinasDoProfessor = disciplinaService.listarPorProfessor(professor);
        List<Turma> turmas = turmaService.listarTodas();

        model.addAttribute("prova", prova);
        model.addAttribute("disciplinas", disciplinasDoProfessor);
        model.addAttribute("turmas", turmas);
        return "prova/formulario";
    }

    @PostMapping("/editar/{id}")
    public String atualizar(@PathVariable Long id, @ModelAttribute Prova provaAtualizada, Principal principal) {
        Usuario professor = usuarioService.buscarPorLogin(principal.getName());
        Prova provaExistente = provaService.buscarPorId(id);

        if (provaExistente == null) {
            return "redirect:/prova/listar";
        }

        provaExistente.setNome(provaAtualizada.getNome());
        provaExistente.setDataAplicacao(provaAtualizada.getDataAplicacao());
        provaExistente.setValorTotal(provaAtualizada.getValorTotal());
        provaExistente.setDisciplina(provaAtualizada.getDisciplina());
        provaExistente.setTurma(provaAtualizada.getTurma());
        provaExistente.setProfessor(professor);

        provaService.salvar(provaExistente);

        return "redirect:/prova/listar";
    }

    @GetMapping("/remover/{id}")
    public String remover(@PathVariable Long id) {
        provaService.deletarPorId(id);
        return "redirect:/prova/listar";
    }
}
