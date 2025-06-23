package com.example.corrige_gabarito.java.repository;

import com.example.corrige_gabarito.java.model.Aluno;
import com.example.corrige_gabarito.java.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface AlunoRepository extends JpaRepository<Aluno, Long> {
    Aluno findByUsuario(Usuario usuario);
    @Query("SELECT a FROM Aluno a JOIN a.turmas t JOIN Prova p ON p.turma.id = t.id WHERE p.id = :provaId")
    List<Aluno> buscarAlunosPorProva(Long provaId);
}
