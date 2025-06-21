package com.example.corrige_gabarito.java.service;

import com.example.corrige_gabarito.java.model.Questao;
import com.example.corrige_gabarito.java.repository.QuestaoRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

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
}
