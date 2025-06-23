package com.example.corrige_gabarito.java.service;

import com.example.corrige_gabarito.java.api.dto.QuestaoComRespostaDTO;
import com.example.corrige_gabarito.java.model.Prova;
import com.example.corrige_gabarito.java.model.Questao;
import com.example.corrige_gabarito.java.model.RespostaAluno;
import com.example.corrige_gabarito.java.repository.ProvaRepository;
import com.example.corrige_gabarito.java.repository.QuestaoRepository;
import com.example.corrige_gabarito.java.repository.RespostaAlunoRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class QuestaoService {

    private final QuestaoRepository questaoRepository;


    public List<Questao> listarPorProva(Long provaId) {
        return questaoRepository.findByProvaId(provaId);
    }

    public void salvar(Questao questao) {
        questaoRepository.save(questao);
    }

    public Questao buscarPorId(Long id) {
        return questaoRepository.findById(id).orElse(null);
    }

    public void deletarPorId(Long id) {
        questaoRepository.deleteById(id);
    }

    public List<QuestaoComRespostaDTO> listarQuestoesComRespostasDoAluno(Long provaId) {

        List<Questao> respostas = listarPorProva(provaId);

        return respostas.stream().map(questao -> {

            return new QuestaoComRespostaDTO(
                    questao.getId(),
                    questao.getEnunciado(),
                    questao.getTipo().name(),
                    questao.getValor().doubleValue()
            );
        }).collect(Collectors.toList());
    }
}
