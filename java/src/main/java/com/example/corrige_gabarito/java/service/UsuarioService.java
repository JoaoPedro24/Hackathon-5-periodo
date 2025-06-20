package com.example.corrige_gabarito.java.service;

import com.example.corrige_gabarito.java.model.Usuario;
import com.example.corrige_gabarito.java.repository.UsuarioRepository;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
@AllArgsConstructor
public class UsuarioService implements UserDetailsService {

@Autowired
    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return usuarioRepository.findByLogin(username)
                .orElseThrow(() -> new UsernameNotFoundException("Usuário não encontrado com o login: " + username));
    }

    @Transactional
    public Usuario salvar(Usuario usuario) {
        if (!usuario.getPassword().startsWith("$2a$")) {
            usuario.setPassword(passwordEncoder.encode(usuario.getPassword()));
        }
        return usuarioRepository.save(usuario);
    }
    public List<Usuario> listarTodos() {
        return usuarioRepository.findAll();
    }

    public Usuario buscarPorId(Long id) {
        return usuarioRepository.findById(id)
                .orElseThrow(() -> new UsernameNotFoundException("Usuário não encontrado com o id: " + id));
    }

    @Transactional
    public void deletarPorId(Long id) {
        usuarioRepository.deleteById(id);
    }
}
