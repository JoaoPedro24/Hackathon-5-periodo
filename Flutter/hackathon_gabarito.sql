CREATE DATABASE IF NOT EXISTS `hackathon_gabarito`;
USE `hackathon_gabarito`;

-- Tabela de Usuários
CREATE TABLE `usuarios` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `nome` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `senha` VARCHAR(255) NOT NULL,
    `perfil` ENUM('ADMINISTRADOR', 'PROFESSOR', 'ALUNO') NOT NULL
);

-- Tabela de Turmas
CREATE TABLE `turmas` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `nome` VARCHAR(255) NOT NULL,
    `ano` INT NOT NULL
);

-- Tabela de Disciplinas
CREATE TABLE `disciplinas` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `nome` VARCHAR(255) NOT NULL
);

-- Tabela de Alunos
CREATE TABLE `alunos` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `nome` VARCHAR(255) NOT NULL,
    `matricula` VARCHAR(255) NOT NULL UNIQUE,
    `usuario_id` INT,
    FOREIGN KEY (`usuario_id`) REFERENCES `usuarios`(`id`)
);

-- Tabela de Associação Turmas-Alunos (muitos para muitos)
CREATE TABLE `turmas_alunos` (
    `turma_id` INT,
    `aluno_id` INT,
    PRIMARY KEY (`turma_id`, `aluno_id`),
    FOREIGN KEY (`turma_id`) REFERENCES `turmas`(`id`),
    FOREIGN KEY (`aluno_id`) REFERENCES `alunos`(`id`)
);

-- Tabela de Provas
CREATE TABLE `provas` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `turma_id` INT NOT NULL,
    `disciplina_id` INT NOT NULL,
    `professor_id` INT NOT NULL,
    `data_prova` DATE NOT NULL,
    `titulo` VARCHAR(255) NOT NULL,
    `gabarito_oficial` TEXT NOT NULL, -- Pode ser JSON ou string delimitada
    FOREIGN KEY (`turma_id`) REFERENCES `turmas`(`id`),
    FOREIGN KEY (`disciplina_id`) REFERENCES `disciplinas`(`id`),
    FOREIGN KEY (`professor_id`) REFERENCES `usuarios`(`id`)
);

-- Tabela de Respostas dos Alunos
CREATE TABLE `respostas_alunos` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `prova_id` INT NOT NULL,
    `aluno_id` INT NOT NULL,
    `respostas_enviadas` TEXT NOT NULL, -- Pode ser JSON ou string delimitada
    `nota` DECIMAL(5,2),
    `data_envio` DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`prova_id`) REFERENCES `provas`(`id`),
    FOREIGN KEY (`aluno_id`) REFERENCES `alunos`(`id`)
);

-- Inserção de dados de exemplo (opcional)

INSERT INTO `usuarios` (`nome`, `email`, `senha`, `perfil`) VALUES
('Admin Geral', 'admin@example.com', 'senha_hash_admin', 'ADMINISTRADOR'),
('Professor Silva', 'professor.silva@example.com', 'senha_hash_prof', 'PROFESSOR'),
('Aluno Souza', 'aluno.souza@example.com', 'senha_hash_aluno', 'ALUNO');

INSERT INTO `turmas` (`nome`, `ano`) VALUES
('Sistemas para Internet - 5º Período', 2025);

INSERT INTO `disciplinas` (`nome`) VALUES
('Banco de Dados'),
('Programação Mobile');

INSERT INTO `alunos` (`nome`, `matricula`, `usuario_id`) VALUES
('Aluno Souza', '2025001', 3);

INSERT INTO `turmas_alunos` (`turma_id`, `aluno_id`) VALUES
(1, 1);

INSERT INTO `provas` (`turma_id`, `disciplina_id`, `professor_id`, `data_prova`, `titulo`, `gabarito_oficial`) VALUES
(1, 1, 2, '2025-06-17', 'Prova de Banco de Dados - Unidade 1', '{"1":"A", "2":"B", "3":"C", "4":"D", "5":"E"}');

INSERT INTO `respostas_alunos` (`prova_id`, `aluno_id`, `respostas_enviadas`, `nota`) VALUES
(1, 1, '{"1":"A", "2":"B", "3":"C", "4":"D", "5":"A"}', 8.00);


