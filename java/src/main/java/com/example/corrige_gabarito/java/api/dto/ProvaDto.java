package com.example.corrige_gabarito.java.api.dto;

import lombok.*;

import java.math.BigDecimal;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProvaDto {

    private Long id;
    private String nome;
    private BigDecimal valorTotal;
    private String disciplina;
    private String turma;
    private List<QuestaoDTO> questoes;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class QuestaoDTO {
        private Long id;
        private String tipo;
        private BigDecimal valor;
        private String enunciado;
        private String respostaCorreta;  // Opcional, pode remover se quiser esconder a resposta correta
    }
}
