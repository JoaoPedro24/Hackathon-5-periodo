package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.model.Aluno;
import com.example.corrige_gabarito.java.model.Usuario;
import com.example.corrige_gabarito.java.service.AlunoService;
import com.example.corrige_gabarito.java.service.UsuarioService;
import lombok.AllArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@AllArgsConstructor
@RequestMapping("/aluno")
public class AlunoController {

    private final AlunoService alunoService;
    private final PasswordEncoder passwordEncoder;


    @GetMapping("/listar")
    public String listar(Model model) {
        model.addAttribute("usuarios", alunoService.listarUsuariosNaoAssociados());
        model.addAttribute("alunos", alunoService.listarTodos());
        return "aluno/lista";
    }

    @PostMapping
    public String salvar(@ModelAttribute Aluno aluno, Model model) {
        return salvarOuAtualizar(aluno, model);
    }

    private String salvarOuAtualizar(Aluno aluno, Model model) {
        try {

            alunoService.salvar(aluno);
            return "redirect:/aluno/listar";

        } catch (Exception e) {
            model.addAttribute("message", "Não foi possível salvar o usuário: " + e.getMessage());
            model.addAttribute("alunos", alunoService.listarTodos());
            model.addAttribute("usuarios", alunoService.listarUsuariosNaoAssociados());
            return "aluno/lista";
        }
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model) {
        Aluno aluno = alunoService.buscarPorId(id);
        if (aluno != null) {
            model.addAttribute("aluno", aluno);
        } else {
            model.addAttribute("aluno", new Aluno());
            model.addAttribute("message", "Aluno não encontrado");
        }
        model.addAttribute("alunos", alunoService.listarTodos());
        model.addAttribute("usuarios", alunoService.listarUsuariosNaoAssociados());
        return "aluno/lista";
    }

    @GetMapping("/remover/{id}")
    public String remover(@PathVariable Long id) {
        alunoService.deletarPorId(id);
        return "redirect:/aluno/listar";
    }
}
