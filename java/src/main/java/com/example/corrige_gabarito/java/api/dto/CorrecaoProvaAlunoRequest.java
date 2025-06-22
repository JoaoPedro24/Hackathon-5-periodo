package com.example.corrige_gabarito.java.api.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
public class CorrecaoProvaAlunoRequest {
    private Long id;
    
    @NotNull(message = "O ID do aluno é obrigatório")
    private Long alunoId;
    
    @NotNull(message = "O ID da prova é obrigatório")
    private Long provaId;
    
    @NotEmpty(message = "A lista de respostas não pode estar vazia")
    private List<@Valid RespostaQuestaoDTO> respostas;
    
    @Data
    public static class RespostaQuestaoDTO {
        @NotNull(message = "O ID da questão é obrigatório")
        private Long questaoId;

        private String resposta;
        
        private String valor;
    }
}
