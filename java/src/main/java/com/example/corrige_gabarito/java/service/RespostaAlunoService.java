package com.example.corrige_gabarito.java.service;

import com.example.corrige_gabarito.java.model.RespostaAluno;
import com.example.corrige_gabarito.java.repository.RespostaAlunoRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class RespostaAlunoService {

    private final RespostaAlunoRepository respostaAlunoRepository;

    public List<RespostaAluno> buscarPorProvaId(Long provaId) {
        return respostaAlunoRepository.findByProvaId(provaId);
    }

    public List<RespostaAluno> buscarPorAlunoId(Long id) {
        return respostaAlunoRepository.findByAlunoId(id);
    }

    public List<RespostaAluno> buscarPorAlunoEProva(Long alunoId, Long provaId) {
        return respostaAlunoRepository.findByAlunoIdAndProvaId(alunoId, provaId);
    }

}
