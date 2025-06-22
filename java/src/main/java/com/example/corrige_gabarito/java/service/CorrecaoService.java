package com.example.corrige_gabarito.java.service;

import com.example.corrige_gabarito.java.api.dto.CorrecaoProvaAlunoRequest;
import com.example.corrige_gabarito.java.api.dto.CorrecaoProvaResponse;
import com.example.corrige_gabarito.java.model.Aluno;
import com.example.corrige_gabarito.java.model.Prova;
import com.example.corrige_gabarito.java.model.Questao;
import com.example.corrige_gabarito.java.model.RespostaAluno;
import com.example.corrige_gabarito.java.repository.QuestaoRepository;
import com.example.corrige_gabarito.java.repository.RespostaAlunoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

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

        // Criando objetos de Aluno e Prova apenas com o ID (evita buscar do banco)
        Aluno aluno = new Aluno();
        aluno.setId(request.getAlunoId());

        Prova prova = new Prova();
        prova.setId(request.getProvaId());

        for (CorrecaoProvaAlunoRequest.RespostaQuestaoDTO respostaDTO : request.getRespostas()) {

            Optional<Questao> optionalQuestao = questoes.stream()
                    .filter(q -> q.getId().equals(respostaDTO.getQuestaoId()))
                    .findFirst();

            if (optionalQuestao.isPresent()) {
                Questao questao = optionalQuestao.get();
                RespostaAluno respostaAluno = new RespostaAluno();

                respostaAluno.setAluno(aluno);
                respostaAluno.setProva(prova);
                respostaAluno.setQuestao(questao);
                respostaAluno.setResposta(respostaDTO.getResposta());

                if (questao.getTipo() == Questao.TipoQuestao.ALTERNATIVA) {
                    boolean acertou = questao.getRespostaCorreta() != null
                            && questao.getRespostaCorreta().equalsIgnoreCase(respostaDTO.getResposta());

                    if (acertou) {
                        totalAcertos++;
                        pontuacaoTotal = pontuacaoTotal.add(questao.getValor());
                        respostaAluno.setValor(questao.getValor());
                    } else {
                        respostaAluno.setValor(BigDecimal.ZERO);
                    }
                } else {
                    BigDecimal valorResposta = BigDecimal.ZERO;
                    try {
                        if (respostaDTO.getValor() != null) {
                            valorResposta = new BigDecimal(respostaDTO.getValor());
                        }
                    } catch (NumberFormatException e) {
                        valorResposta = BigDecimal.ZERO;
                    }
                    respostaAluno.setValor(valorResposta);
                }

                respostasParaSalvar.add(respostaAluno);
            }
        }

        respostaAlunoRepository.saveAll(respostasParaSalvar);

        return new CorrecaoProvaResponse(totalAcertos, pontuacaoTotal.doubleValue());
    }
}
