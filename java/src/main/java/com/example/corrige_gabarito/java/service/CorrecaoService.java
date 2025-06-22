package com.example.corrige_gabarito.java.service;

import com.example.corrige_gabarito.java.api.dto.CorrecaoProvaAlunoRequest;
import com.example.corrige_gabarito.java.api.dto.CorrecaoProvaResponse;
import com.example.corrige_gabarito.java.model.Questao;
import com.example.corrige_gabarito.java.repository.QuestaoRepository;
import com.example.corrige_gabarito.java.repository.RespostaAlunoRepository;
import com.example.corrige_gabarito.java.model.RespostaAluno;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CorrecaoService {

    private final QuestaoRepository questaoRepository;
    private final RespostaAlunoRepository respostaAlunoRepository;

    public CorrecaoProvaResponse corrigirProvaAluno(CorrecaoProvaAlunoRequest request) {
        List<Questao> questoes = questaoRepository.findByProvaId(request.getProvaId());

        int totalAcertos = 0;
        BigDecimal pontuacaoTotal = BigDecimal.ZERO;

        List<RespostaAluno> respostasParaSalvar = new ArrayList<>();

        for (CorrecaoProvaAlunoRequest.RespostaAlunoDTO respostaDTO : request.getRespostasAluno()) {
            Questao questao = questoes.stream()
                    .filter(q -> {
                        String enunciadoQuestao = String.valueOf(q.getEnunciado());
                        String enunciadoResposta = String.valueOf(respostaDTO.getEnunciado());
                        return enunciadoQuestao.equals(enunciadoResposta) && q.getTipo() == Questao.TipoQuestao.ALTERNATIVA;
                    })
                    .findFirst()
                    .orElse(null);

            if (questao != null) {
                boolean acertou = questao.getRespostaCorreta().equalsIgnoreCase(respostaDTO.getResposta());

                if (acertou) {
                    totalAcertos++;
                    pontuacaoTotal = pontuacaoTotal.add(questao.getValor());
                }

                RespostaAluno respostaAluno = new RespostaAluno();
                respostaAluno.setAlunoId(request.getAlunoId());
                respostaAluno.setProvaId(request.getProvaId());
                respostaAluno.setEnunciado(respostaDTO.getEnunciado());
                respostaAluno.setResposta(respostaDTO.getResposta());

                respostasParaSalvar.add(respostaAluno);
            }
        }


        respostaAlunoRepository.saveAll(respostasParaSalvar);

        return new CorrecaoProvaResponse(totalAcertos, pontuacaoTotal.doubleValue());
    }
}
