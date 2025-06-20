package com.example.corrige_gabarito.java.repository;

import com.example.corrige_gabarito.java.model.Professor;
import org.springframework.data.jpa.repository.JpaRepository;


public interface ProfessorRepository extends JpaRepository<Professor, Long> {

}
