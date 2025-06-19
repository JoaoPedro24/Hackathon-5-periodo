package com.example.corrige_gabarito.java;

import com.example.corrige_gabarito.java.model.Usuario;
import com.example.corrige_gabarito.java.repository.UsuarioRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@SpringBootApplication
public class CorrigeGabaritoApplication {

	public static void main(String[] args) {
		SpringApplication.run(CorrigeGabaritoApplication.class, args);
	}

	@Bean
	public CommandLineRunner loadAdminUser(UsuarioRepository usuarioRepository) {
		return args -> {
			if (usuarioRepository.findByLogin("admin").isEmpty()) {
				usuarioRepository.save(new Usuario(
						null,
						"Administrador",
						new BCryptPasswordEncoder().encode("admin"),
						"admin",
						"ADMIN"
				));
				System.out.println("Usuário admin criado com sucesso!");
			} else {
				System.out.println("Usuário admin já existe. Não será recriado.");
			}
		};
	}
}
