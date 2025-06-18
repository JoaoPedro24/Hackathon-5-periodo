package com.example.corrige_gabarito.java.service;


import com.example.corrige_gabarito.java.model.Usuario;
import com.example.corrige_gabarito.java.repository.UsuarioRepository;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class UsuarioService implements UserDetailsService {

    private final UsuarioRepository usuarioRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return usuarioRepository.findByLogin(username);
    }

    @Transactional
    public void salvar(Usuario usuario) {
        usuarioRepository.save(usuario);
    }

    public List<Usuario> listararTodos() {
        return usuarioRepository.findAll();
    }

    public Usuario buscarPorId(Long id) {
        return usuarioRepository.findById(id).get();
    }

    public void deletarPorId(Long id) {
        usuarioRepository.deleteById(id);
    }
}
