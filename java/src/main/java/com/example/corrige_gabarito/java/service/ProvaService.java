package com.example.corrige_gabarito.java.service;

import com.example.corrige_gabarito.java.model.Prova;
import com.example.corrige_gabarito.java.repository.ProvaRepository;
import com.example.corrige_gabarito.java.repository.QuestaoRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Set;

@Service
@AllArgsConstructor
public class ProvaService {

    private final ProvaRepository provaRepository;
    private final QuestaoRepository questaoRepository;

    public List<Prova> listarTodas() {
        return provaRepository.findAll();
    }

    public void salvar(Prova prova) {
        provaRepository.save(prova);
    }

    public Prova buscarPorId(Long id) {
        return provaRepository.findById(id).orElse(null);
    }

    public void deletarPorId(Long id) {
        provaRepository.deleteById(id);
    }

    public List<Prova> listarPorProfessorId(Long professorId) {
        return provaRepository.findByProfessorId(professorId);
    }

    public List<Prova> buscarPorTurmas(Set<Long> idsTurmas) {
        return provaRepository.findByTurmaIdIn(idsTurmas);
    }

    public BigDecimal calcularNotaMaxima(Long provaId) {
        return questaoRepository.somarValorTotalDaProva(provaId);
    }


}
