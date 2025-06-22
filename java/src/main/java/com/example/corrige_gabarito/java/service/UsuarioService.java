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
public class UsuarioService implements UserDetailsService {

@Autowired
    private final UsuarioRepository usuarioRepository;
    public UsuarioService(UsuarioRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // ENCONTRE SEU USUÁRIO NO BANCO DE DADOS
        Usuario usuario = usuarioRepository.findByLogin(username)
                .orElseThrow(() -> new UsernameNotFoundException("Usuário não encontrado: " + username));

        // ESTA LINHA É CRÍTICA! DEVE RETORNAR SUA INSTÂNCIA DE USUARIO!
        return usuario; // <<<<<<<<<<<<<<<< ESTA É A LINHA QUE DEVE ESTAR ASSIM
        // NÃO PODE SER: return new org.springframework.security.core.userdetails.User(...)
    }

    @Transactional
    public Usuario salvar(Usuario usuario) {
        // A senha JÁ DEVE ESTAR CODIFICADA quando este método for chamado.
        // O PasswordEncoder deve ser usado ANTES de chamar .salvar()
        // por exemplo, no seu AuthController ou em um serviço de registro.
        return usuarioRepository.save(usuario);
    }
    public List<Usuario> listarTodos() {
        return usuarioRepository.findAll();
    }

    public Usuario buscarPorId(Long id) {
        return usuarioRepository.findById(id)
                .orElseThrow(() -> new UsernameNotFoundException("Usuário não encontrado com o id: " + id));
    }

    public List<Usuario> listarUsuariosPorRole(String role) {
        return usuarioRepository.findByRoleIgnoreCase(role);
    }

    @Transactional
    public void deletarPorId(Long id) {
        usuarioRepository.deleteById(id);
    }

    public Usuario buscarPorLogin(String login) {
        return usuarioRepository.findByLogin(login)
                .orElseThrow(() -> new UsernameNotFoundException("Usuário não encontrado com o login: " + login));
    }

}


