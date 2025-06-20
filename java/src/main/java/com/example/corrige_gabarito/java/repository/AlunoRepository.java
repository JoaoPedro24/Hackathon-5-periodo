package com.example.corrige_gabarito.java.repository;

import com.example.corrige_gabarito.java.model.Aluno;
import org.springframework.data.jpa.repository.JpaRepository;



public interface AlunoRepository extends JpaRepository<Aluno, Long> {

}
