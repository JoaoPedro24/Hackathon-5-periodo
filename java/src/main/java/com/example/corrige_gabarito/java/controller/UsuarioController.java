package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.model.Usuario;
import com.example.corrige_gabarito.java.service.UsuarioService;
import lombok.AllArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@AllArgsConstructor
@RequestMapping("/usuario")
public class UsuarioController {

    private final UsuarioService usuarioService;
    private final PasswordEncoder passwordEncoder;

    @GetMapping
    public String iniciar(Model model) {
        model.addAttribute("usuario", new Usuario());
        return "usuario/formulario";
    }

    @GetMapping("/listar")
    public String listar(Model model) {
        model.addAttribute("usuarios", usuarioService.listarTodos());
        model.addAttribute("usuario", new Usuario());
        return "usuario/lista";
    }

    @PostMapping
    public String salvar(@ModelAttribute Usuario usuario, Model model) {
        return salvarOuAtualizar(usuario, model);
    }
    
    @PostMapping("/editar/{id}")
    public String atualizarPost(@PathVariable Long id, @ModelAttribute Usuario usuario, Model model) {
        usuario.setId(id);
        return salvarOuAtualizar(usuario, model);
    }
    
    private String salvarOuAtualizar(Usuario usuario, Model model) {
        try {
            // Se for uma edição e a senha não foi alterada, mantém a senha atual
            if (usuario.getId() != null && (usuario.getPassword() == null || usuario.getPassword().isEmpty())) {
                Usuario usuarioExistente = usuarioService.buscarPorId(usuario.getId());
                usuario.setPassword(usuarioExistente.getPassword());
            } else if (usuario.getPassword() != null && !usuario.getPassword().isEmpty()) {
                // Se for um novo usuário ou a senha foi alterada, criptografa a nova senha
                usuario.setPassword(passwordEncoder.encode(usuario.getPassword()));
            }

            usuarioService.salvar(usuario);
            return "redirect:/usuario/listar";

        } catch (Exception e) {
            model.addAttribute("message", "Não foi possível salvar o usuário: " + e.getMessage());
            model.addAttribute("usuarios", usuarioService.listarTodos());
            return "usuario/lista";
        }
    }

    @GetMapping("/editar/{id}")
    public String atualizar(@PathVariable Long id, Model model) {
        Usuario usuario = usuarioService.buscarPorId(id);
        if (usuario != null) {
            model.addAttribute("usuario", usuario);
        } else {
            model.addAttribute("usuario", new Usuario());
            model.addAttribute("message", "Usuário não encontrado");
        }
        model.addAttribute("usuarios", usuarioService.listarTodos());
        return "usuario/lista";
    }

    @GetMapping("/remover/{id}")
    public String deletar(@PathVariable Long id) {
        usuarioService.deletarPorId(id);
        return "redirect:/usuario/listar";
    }
}
