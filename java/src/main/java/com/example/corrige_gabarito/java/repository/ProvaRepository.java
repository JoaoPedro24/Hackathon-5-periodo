package com.example.corrige_gabarito.java.repository;

import com.example.corrige_gabarito.java.model.Prova;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Set;

public interface ProvaRepository extends JpaRepository<Prova, Long> {
    List<Prova> findByProfessorId(Long professorId);
    List<Prova> findByTurmaIdIn(Set<Long> idsTurmas);


}
