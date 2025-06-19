package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.model.Usuario;
import com.example.corrige_gabarito.java.service.UsuarioService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/usuario")
public class UsuarioController {

    private final UsuarioService usuarioService;

    @GetMapping
    public String iniciar() {
        return "usuario/formulario";
    }

    @GetMapping("listar")
    public String listar(Usuario usuario, Model model) {
        model.addAttribute("usuarios", usuarioService.listararTodos());
        return "usuario/lista";
    }

    @PostMapping
    public String salvar(Usuario usuario, Model model) {
        try {
            usuarioService.salvar(usuario);
            return "redirect:usuario/listar";
        } catch (Exception e) {
            model.addAttribute("message", "Não foi possível savar");
            return listar(usuario, model);
        }
    }

    @GetMapping("editar/{id}")
    public String atualizar(@PathVariable Long id, Model model) {
        model.addAttribute("usuario", usuarioService.buscarPorId(id));
        return "usuario/formulario";
    }

    @GetMapping("remover/{id}")
    public String deletar(@PathVariable Long id, Model model) {
        usuarioService.deletarPorId(id);
        return "redirect:usuario/listar";
    }
}
