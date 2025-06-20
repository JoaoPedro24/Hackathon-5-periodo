package com.example.corrige_gabarito.java.repository;

import com.example.corrige_gabarito.java.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
    Optional<Usuario> findByLogin(String login);
    List<Usuario> findByRoleIgnoreCase(String role);
}
