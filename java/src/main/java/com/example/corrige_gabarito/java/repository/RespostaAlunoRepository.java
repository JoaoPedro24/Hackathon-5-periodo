package com.example.corrige_gabarito.java.repository;


import com.example.corrige_gabarito.java.model.RespostaAluno;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RespostaAlunoRepository extends JpaRepository<RespostaAluno, Long> {
    List<RespostaAluno> findByAlunoIdAndProvaId(Long alunoId, Long provaId);
    List<RespostaAluno> findByProvaId(Long provaId);
    List<RespostaAluno> findByAlunoId(Long alunoId);


}
