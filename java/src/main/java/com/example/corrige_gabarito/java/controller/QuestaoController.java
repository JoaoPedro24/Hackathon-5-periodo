package com.example.corrige_gabarito.java.controller;

import com.example.corrige_gabarito.java.model.Prova;
import com.example.corrige_gabarito.java.model.Questao;
import com.example.corrige_gabarito.java.service.ProvaService;
import com.example.corrige_gabarito.java.service.QuestaoService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@AllArgsConstructor
@RequestMapping("/questao")
public class QuestaoController {

    private final QuestaoService questaoService;
    private final ProvaService provaService;


    @GetMapping("/listar/{provaId}")
    public String listar(@PathVariable Long provaId, Model model) {
        Prova prova = provaService.buscarPorId(provaId);

        if (prova == null) {
            return "redirect:/prova/listar";
        }

        model.addAttribute("prova", prova);
        model.addAttribute("questoes", questaoService.listarPorProva(provaId));

        return "questao/lista";
    }


    // ✅ Exibir formulário de nova questão
    @GetMapping("/nova/{provaId}")
    public String nova(@PathVariable Long provaId, Model model) {
        Prova prova = provaService.buscarPorId(provaId);
        if (prova == null) {
            return "redirect:/prova/listar";
        }
        Questao questao = new Questao();
        questao.setProva(prova);
        model.addAttribute("questao", questao);
        return "questao/formulario";
    }

    // ✅ Salvar questão (tanto nova quanto editada)
    @PostMapping("/salvar")
    public String salvar(@ModelAttribute Questao questao) {
        questaoService.salvar(questao);
        return "redirect:/questao/listar/" + questao.getProva().getId();
    }

    // ✅ Editar questão existente
    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model) {
        Questao questao = questaoService.buscarPorId(id);
        if (questao == null) {
            return "redirect:/prova/listar";
        }
        model.addAttribute("questao", questao);
        return "questao/formulario";
    }

    // ✅ Remover questão
    @GetMapping("/remover/{id}")
    public String remover(@PathVariable Long id) {
        Questao questao = questaoService.buscarPorId(id);
        if (questao != null) {
            Long provaId = questao.getProva().getId();
            questaoService.deletarPorId(id);
            return "redirect:/questao/listar/" + provaId;
        }
        return "redirect:/prova/listar";
    }
}
