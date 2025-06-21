package com.example.corrige_gabarito.java.repository;

import com.example.corrige_gabarito.java.model.Disciplina;
import com.example.corrige_gabarito.java.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;


public interface DisciplinaRepository extends JpaRepository<Disciplina, Long> {
    List<Disciplina> findByProfessor(Usuario professor);

}
