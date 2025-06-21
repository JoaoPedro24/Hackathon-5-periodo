package com.example.corrige_gabarito.java.security;

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
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.security.web.util.matcher.RequestMatcher;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
    RequestMatcher authMatcher = request -> request.getRequestURI().startsWith("/auth/");

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) throws Exception {
        return httpSecurity
                .csrf(AbstractHttpConfigurer::disable)
                .cors(Customizer.withDefaults())
                .headers(header -> header.frameOptions(config -> config.sameOrigin()))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/auth/login").permitAll()    // CORRIGIDO AQUI
                        .requestMatchers("/images/**", "/css/**", "/error/**").permitAll()
                        .requestMatchers("/").permitAll()
                        .requestMatchers("/banco/**", "/usuario/**").hasRole("ADMIN")
                        .requestMatchers("/provas/**", "/gabaritos/**").hasRole("PROFESSOR")
                        .requestMatchers("/notas/**").hasAnyRole("ALUNO", "ADMIN", "PROFESSOR")
                        .requestMatchers("/api/**").hasAnyRole("ADMIN", "PROFESSOR", "ALUNO")
                        .requestMatchers("/aluno/**").permitAll()

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
                        // 👉 Global para qualquer rota não autenticada que não seja /auth/**
                        .authenticationEntryPoint((request, response, authException) -> {
                            response.setContentType("application/json");
                            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                            response.getWriter().write("{\"error\": \"Unauthorized\"}");
                        })

                        // Específico para /auth/** (opcional, mas redundante se global já cobre)
                        .defaultAuthenticationEntryPointFor(
                                (request, response, authException) -> {
                                    response.setContentType("application/json");
                                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                                    response.getWriter().write("{\"error\": \"Unauthorized\"}");
                                },
                                request -> request.getRequestURI().startsWith("/auth/")
                        )
                )
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
