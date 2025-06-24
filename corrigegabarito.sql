-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 24/06/2025 às 03:41
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `corrigegabarito`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `alunos`
--

CREATE TABLE `alunos` (
  `id` bigint(20) NOT NULL,
  `matricula` varchar(255) DEFAULT NULL,
  `usuario_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `disciplinas`
--

CREATE TABLE `disciplinas` (
  `id` bigint(20) NOT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `professor_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `disciplina_alunos`
--

CREATE TABLE `disciplina_alunos` (
  `disciplina_id` bigint(20) NOT NULL,
  `aluno_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `prova`
--

CREATE TABLE `prova` (
  `id` bigint(20) NOT NULL,
  `data_aplicacao` date DEFAULT NULL,
  `nome` varchar(255) NOT NULL,
  `valor_total` decimal(38,2) NOT NULL,
  `disciplina_id` bigint(20) NOT NULL,
  `professor_id` bigint(20) NOT NULL,
  `turma_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `questao`
--

CREATE TABLE `questao` (
  `id` bigint(20) NOT NULL,
  `enunciado` varchar(255) NOT NULL,
  `resposta_correta` varchar(255) DEFAULT NULL,
  `tipo` enum('ALTERNATIVA','DISCURSIVA') NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `prova_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `respostas_aluno`
--

CREATE TABLE `respostas_aluno` (
  `id` bigint(20) NOT NULL,
  `resposta` varchar(255) DEFAULT NULL,
  `valor` decimal(10,2) NOT NULL,
  `aluno_id` bigint(20) NOT NULL,
  `prova_id` bigint(20) NOT NULL,
  `questao_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `turma`
--

CREATE TABLE `turma` (
  `id` bigint(20) NOT NULL,
  `nome` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `turma_aluno`
--

CREATE TABLE `turma_aluno` (
  `turma_id` bigint(20) NOT NULL,
  `aluno_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuario`
--

CREATE TABLE `usuario` (
  `id` bigint(20) NOT NULL,
  `login` varchar(255) DEFAULT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `usuario`
--

INSERT INTO `usuario` (`id`, `login`, `nome`, `password`, `role`) VALUES
(1, 'admin', 'Administrador', '$2a$10$Ora6EabpwIlQui3PAjyCqOStY.BOZDUlqc38t/c4uYxLr9WayNley', 'ADMIN');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `alunos`
--
ALTER TABLE `alunos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UKqswsnqp4vhi83nrrxk8k4nxoh` (`usuario_id`);

--
-- Índices de tabela `disciplinas`
--
ALTER TABLE `disciplinas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK3nicri39kr2prr5pn9osdkuiw` (`professor_id`);

--
-- Índices de tabela `disciplina_alunos`
--
ALTER TABLE `disciplina_alunos`
  ADD KEY `FKfu0tmtao1hqq9rvdu8ordn1fw` (`aluno_id`),
  ADD KEY `FKat1ypqk1yv7g797gk2gfh2kvm` (`disciplina_id`);

--
-- Índices de tabela `prova`
--
ALTER TABLE `prova`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKsk0g671gfkf87oo1d6ex11air` (`disciplina_id`),
  ADD KEY `FKna0qpnab1wtytcdvayh82fh67` (`professor_id`),
  ADD KEY `FKnc0asx3bnw4mgqri5pwks5a4u` (`turma_id`);

--
-- Índices de tabela `questao`
--
ALTER TABLE `questao`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK18j1n6qwbeoy3fpsrol758jtu` (`prova_id`);

--
-- Índices de tabela `respostas_aluno`
--
ALTER TABLE `respostas_aluno`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKr7e8nwf2q3a2ntbvcg9e5rsk1` (`aluno_id`),
  ADD KEY `FKbntktoldqwqerdv71lg485srg` (`prova_id`),
  ADD KEY `FKsg0evhaeg8lf49hnvoir4dm2f` (`questao_id`);

--
-- Índices de tabela `turma`
--
ALTER TABLE `turma`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `turma_aluno`
--
ALTER TABLE `turma_aluno`
  ADD PRIMARY KEY (`turma_id`,`aluno_id`),
  ADD KEY `FKnsgaqcfg77bwlwi0flaawnpye` (`aluno_id`);

--
-- Índices de tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `alunos`
--
ALTER TABLE `alunos`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `disciplinas`
--
ALTER TABLE `disciplinas`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `prova`
--
ALTER TABLE `prova`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `questao`
--
ALTER TABLE `questao`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `respostas_aluno`
--
ALTER TABLE `respostas_aluno`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `turma`
--
ALTER TABLE `turma`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `alunos`
--
ALTER TABLE `alunos`
  ADD CONSTRAINT `FK7ek4tkjpst2i361jhac0d5yic` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`);

--
-- Restrições para tabelas `disciplinas`
--
ALTER TABLE `disciplinas`
  ADD CONSTRAINT `FK3nicri39kr2prr5pn9osdkuiw` FOREIGN KEY (`professor_id`) REFERENCES `usuario` (`id`);

--
-- Restrições para tabelas `disciplina_alunos`
--
ALTER TABLE `disciplina_alunos`
  ADD CONSTRAINT `FKat1ypqk1yv7g797gk2gfh2kvm` FOREIGN KEY (`disciplina_id`) REFERENCES `disciplinas` (`id`),
  ADD CONSTRAINT `FKfu0tmtao1hqq9rvdu8ordn1fw` FOREIGN KEY (`aluno_id`) REFERENCES `alunos` (`id`);

--
-- Restrições para tabelas `prova`
--
ALTER TABLE `prova`
  ADD CONSTRAINT `FKna0qpnab1wtytcdvayh82fh67` FOREIGN KEY (`professor_id`) REFERENCES `usuario` (`id`),
  ADD CONSTRAINT `FKnc0asx3bnw4mgqri5pwks5a4u` FOREIGN KEY (`turma_id`) REFERENCES `turma` (`id`),
  ADD CONSTRAINT `FKsk0g671gfkf87oo1d6ex11air` FOREIGN KEY (`disciplina_id`) REFERENCES `disciplinas` (`id`);

--
-- Restrições para tabelas `questao`
--
ALTER TABLE `questao`
  ADD CONSTRAINT `FK18j1n6qwbeoy3fpsrol758jtu` FOREIGN KEY (`prova_id`) REFERENCES `prova` (`id`);

--
-- Restrições para tabelas `respostas_aluno`
--
ALTER TABLE `respostas_aluno`
  ADD CONSTRAINT `FKbntktoldqwqerdv71lg485srg` FOREIGN KEY (`prova_id`) REFERENCES `prova` (`id`),
  ADD CONSTRAINT `FKr7e8nwf2q3a2ntbvcg9e5rsk1` FOREIGN KEY (`aluno_id`) REFERENCES `alunos` (`id`),
  ADD CONSTRAINT `FKsg0evhaeg8lf49hnvoir4dm2f` FOREIGN KEY (`questao_id`) REFERENCES `questao` (`id`);

--
-- Restrições para tabelas `turma_aluno`
--
ALTER TABLE `turma_aluno`
  ADD CONSTRAINT `FK8jlmncan0ekxtbsjfdgwcigtn` FOREIGN KEY (`turma_id`) REFERENCES `turma` (`id`),
  ADD CONSTRAINT `FKnsgaqcfg77bwlwi0flaawnpye` FOREIGN KEY (`aluno_id`) REFERENCES `alunos` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
