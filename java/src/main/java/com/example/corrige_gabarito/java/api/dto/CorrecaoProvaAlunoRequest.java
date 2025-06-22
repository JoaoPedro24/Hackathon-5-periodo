package com.example.corrige_gabarito.java.api.dto;
import lombok.Data;

import java.util.List;

@Data
public class CorrecaoProvaAlunoRequest {
    private Long alunoId;
    private Long provaId;
    private List<RespostaAlunoDTO> respostasAluno;

    @Data
    public static class RespostaAlunoDTO {
        private int enunciado;
        private String resposta;
    }
}
