package com.example.corrige_gabarito.java.repository;

import com.example.corrige_gabarito.java.model.Questao;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface QuestaoRepository extends JpaRepository<Questao, Long> {
    List<Questao> findByProvaId(Long provaId);
}
