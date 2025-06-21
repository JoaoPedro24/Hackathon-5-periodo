package com.example.corrige_gabarito.java.model;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Questao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String enunciado;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TipoQuestao tipo;

    @Column(precision = 10, scale = 2, nullable = false)
    private BigDecimal valor;

    private String respostaCorreta;

    @ManyToOne
    @JoinColumn(name = "prova_id", nullable = false)
    private Prova prova;

    /**
     * Enum representando os tipos de questão possíveis
     */
    public enum TipoQuestao {
        DISCURSIVA,
        ALTERNATIVA
    }
}
