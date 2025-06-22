package com.example.corrige_gabarito.java.security;

import com.example.corrige_gabarito.java.api.JwtAuthenticationFilter;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter; // Injete o filtro JWT
    public SecurityConfig(JwtAuthenticationFilter jwtAuthenticationFilter, AuthenticationConfiguration authenticationConfiguration) throws Exception {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;

    }
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) throws Exception {
        return httpSecurity
                .csrf(AbstractHttpConfigurer::disable)
                .cors(Customizer.withDefaults())
                .headers(header -> header.frameOptions(config -> config.sameOrigin()))
                .authorizeHttpRequests(auth -> auth
                        // 1. URLs totalmente públicas (sem autenticação)
                        .requestMatchers("/auth/**").permitAll()
                        .requestMatchers("/images/**", "/css/**", "/error/**").permitAll()
                        .requestMatchers("/").permitAll()
                        .requestMatchers("/aluno/**").permitAll() // Se esta rota também for pública (ou se for uma rota de registro de aluno)

                        // 2. URLs específicas para ADMIN (as mais restritivas)
                        .requestMatchers("/banco/**", "/usuario/**").hasRole("ADMIN")
                        // Adicione aqui qualquer outra URL /api/alguma_rota_de_admin que você tenha
                        // Exemplo: .requestMatchers("/api/admin/configuracoes/**").hasRole("ADMIN")
                        // Exemplo: .requestMatchers("/api/usuarios/**").hasRole("ADMIN") // Se /api/usuarios for apenas para admin

                        // 3. URLs específicas para PROFESSOR (mais restritivas que as gerais)
                        .requestMatchers("/provas/**", "/gabaritos/**").hasRole("PROFESSOR")
                        // Adicione aqui qualquer outra URL /api/alguma_rota_de_professor que você tenha
                        // Exemplo: .requestMatchers("/api/disciplinas/**").hasRole("PROFESSOR")

                        // 4. URLs específicas para APIs que exigem roles específicas (antes da /api/** genérica)
                        // Esta é a regra de /api/provas que você já tinha, está no lugar correto agora em relação à /api/**
                        .requestMatchers("/api/provas/**").hasAnyRole("ADMIN", "PROFESSOR", "ALUNO") // Mantenha "ALUNO" se for o caso

                        // 5. URLs para notas (também específica, mas para múltiplos perfis)
                        .requestMatchers("/notas/**").hasAnyRole("ALUNO", "ADMIN", "PROFESSOR")

                        // 6. A REGRA GENÉRICA PARA /API/** DEVE VIR POR ÚLTIMO ENTRE AS REGRAS DE API!
                        // Ela vai capturar qualquer /api/ que NÃO tenha sido coberto pelas regras mais específicas acima.
                        .requestMatchers("/api/**").hasAnyRole("ADMIN", "PROFESSOR", "ALUNO") // Se houver APIs gerais para todos

                        // 7. Qualquer outra requisição que não foi capturada acima, deve estar autenticada.
                        .anyRequest().authenticated()
                )
                .formLogin(login -> login
                        .loginPage("/login")
                        .defaultSuccessUrl("/", true)
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login")
                        .permitAll()
                )
                .exceptionHandling(exception -> exception
                        .authenticationEntryPoint((request, response, authException) -> {
                            response.setContentType("application/json");
                            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                            response.getWriter().write("{\"error\": \"Unauthorized\"}");
                        })
                        .defaultAuthenticationEntryPointFor(
                                (request, response, authException) -> {
                                    response.setContentType("application/json");
                                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                                    response.getWriter().write("{\"error\": \"Unauthorized\"}");
                                },
                                request -> request.getRequestURI().startsWith("/auth/")
                        )
                )
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
                .build();
    }


    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }
}
