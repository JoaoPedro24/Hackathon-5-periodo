package com.example.corrige_gabarito.java.service;

import com.example.corrige_gabarito.java.model.Prova;
import com.example.corrige_gabarito.java.repository.ProvaRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class ProvaService {

    private final ProvaRepository provaRepository;

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

}
