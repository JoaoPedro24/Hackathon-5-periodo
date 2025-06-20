package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.model.Aluno;
import com.example.corrige_gabarito.java.model.Usuario;
import com.example.corrige_gabarito.java.service.AlunoService;
import com.example.corrige_gabarito.java.service.UsuarioService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@AllArgsConstructor
@RequestMapping("/aluno")
public class AlunoController {

    private final AlunoService alunoService;
    private final UsuarioService usuarioService;


    @GetMapping
    public String form(Aluno aluno) {
        return "aluno/formulario";
    }

    @GetMapping("/listar")
    public String listar(Model model) {
        List<Aluno> alunos = alunoService.listarTodos();
        List<Usuario> usuarios = usuarioService.listarUsuariosPorRole("ALUNO");
        model.addAttribute("usuarios", usuarios);
        model.addAttribute("alunos", alunos);
        return "aluno/lista";
    }

    @PostMapping
    public String salvar(Aluno aluno) {
        alunoService.salvar(aluno);
        return "redirect:/aluno/listar";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model) {
        Aluno aluno = alunoService.buscarPorId(id);
        model.addAttribute("aluno", aluno);
        return "aluno/formulario";
    }

    @GetMapping("/remover/{id}")
    public String remover(@PathVariable Long id) {
        alunoService.deletarPorId(id);
        return "redirect:/aluno/listar";
    }
}
