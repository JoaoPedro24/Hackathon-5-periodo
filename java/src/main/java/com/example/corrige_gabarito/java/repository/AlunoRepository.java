package com.example.corrige_gabarito.java.repository;

import com.example.corrige_gabarito.java.model.Aluno;
import com.example.corrige_gabarito.java.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AlunoRepository extends JpaRepository<Aluno, Long> {
    Aluno findByUsuario(Usuario usuario);
}
