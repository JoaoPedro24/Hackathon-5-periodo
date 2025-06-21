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
    public String salvar(@ModelAttribute Prova prova, Principal principal, Model model) {
        return salvarOuAtualizar(prova, principal, model);
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
        model.addAttribute("provas", provaService.listarTodas());

        return "prova/lista";
    }


    @GetMapping("/remover/{id}")
    public String remover(@PathVariable Long id) {
        provaService.deletarPorId(id);
        return "redirect:/prova/listar";
    }

    /**
     * Método auxiliar para salvar ou atualizar prova (evitando duplicação de código)
     */
    private String salvarOuAtualizar(Prova prova, Principal principal, Model model) {
        try {
            Usuario professor = usuarioService.buscarPorLogin(principal.getName());
            prova.setProfessor(professor);

            if (prova.getQuestoes() != null) {
                prova.getQuestoes().forEach(q -> q.setProva(prova));
            }

            System.out.println(prova);
            System.out.println(prova.getQuestoes());

            provaService.salvar(prova);
            return "redirect:/prova/listar";

        } catch (Exception e) {
            model.addAttribute("message", "Não foi possível salvar a prova: " + e.getMessage());
            model.addAttribute("provas", provaService.listarTodas());
            model.addAttribute("disciplinas", disciplinaService.listarPorProfessor(usuarioService.buscarPorLogin(principal.getName())));
            model.addAttribute("turmas", turmaService.listarTodas());
            model.addAttribute("prova", prova);
            return "prova/lista";
        }
    }
}
