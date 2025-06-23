package com.example.corrige_gabarito.java.repository;

import com.example.corrige_gabarito.java.model.Questao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.math.BigDecimal;
import java.util.List;

public interface QuestaoRepository extends JpaRepository<Questao, Long> {
    List<Questao> findByProvaId(Long provaId);
    @Query("SELECT COALESCE(SUM(q.valor), 0) FROM Questao q WHERE q.prova.id = :provaId")
    BigDecimal somarValorTotalDaProva(Long provaId);

}
