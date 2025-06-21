package com.example.corrige_gabarito.java.repository;

import com.example.corrige_gabarito.java.model.Aluno;
import com.example.corrige_gabarito.java.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
    Optional<Usuario> findByLogin(String login);
    List<Usuario> findByRoleIgnoreCase(String role);
    
    @Query("SELECT u FROM Usuario u WHERE u.role = 'ALUNO' AND NOT EXISTS (SELECT 1 FROM Aluno a WHERE a.usuario = u)")
    List<Usuario> findAlunosNaoAssociados();
}
