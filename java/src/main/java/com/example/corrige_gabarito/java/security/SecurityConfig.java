package com.example.corrige_gabarito.java.security;

import com.example.corrige_gabarito.java.api.JwtAuthenticationFilter;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    private final AuthenticationSuccessHandler customSuccessHandler;

    public SecurityConfig(JwtAuthenticationFilter jwtAuthenticationFilter, AuthenticationSuccessHandler customSuccessHandler, AuthenticationConfiguration authenticationConfiguration) throws Exception {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
        this.customSuccessHandler = customSuccessHandler;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) throws Exception {
        return httpSecurity
                .csrf(AbstractHttpConfigurer::disable)
                .cors(Customizer.withDefaults())
                .headers(header -> header.frameOptions(config -> config.sameOrigin()))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/auth/**").permitAll()
                        .requestMatchers("/images/**", "/css/**", "/error/**").permitAll()
                        .requestMatchers(HttpMethod.POST, "/aluno/**").hasAnyRole("ALUNO", "ADMIN")
                        .requestMatchers("/aluno/minhas-provas**", "aluno/respostas/**").hasAnyRole("ALUNO", "ADMIN")
                        .requestMatchers("/", "/banco/**", "/usuario/**", "/aluno/**","/disciplina/**","/turma/**").hasRole("ADMIN")
                        .requestMatchers("/prova/**").hasAnyRole("ADMIN","PROFESSOR")
                        .requestMatchers("/api/provas/**").hasRole("PROFESSOR")
                        .requestMatchers("/api/**").hasRole("PROFESSOR")
                        .anyRequest().authenticated()
                )
                .formLogin(login -> login
                        .loginPage("/login")
                        .successHandler(customSuccessHandler)
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login")
                        .permitAll()
                )
                .exceptionHandling(exception -> exception
                        .accessDeniedHandler((request, response, accessDeniedException) -> {
                            String acceptHeader = request.getHeader("Accept");
                            String requestUri = request.getRequestURI();

                            if (requestUri.startsWith("/api/") || (acceptHeader != null && acceptHeader.contains("application/json"))) {
                                response.setContentType("application/json");
                                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                                response.getWriter().write("{\"error\": \"Forbidden\"}");
                            } else {
                                response.sendRedirect("/403");
                            }
                        })
                        .authenticationEntryPoint((request, response, authException) -> {
                            String acceptHeader = request.getHeader("Accept");
                            String requestUri = request.getRequestURI();

                            if (requestUri.startsWith("/api/") || (acceptHeader != null && acceptHeader.contains("application/json"))) {
                                response.setContentType("application/json");
                                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                                response.getWriter().write("{\"error\": \"Unauthorized\"}");
                            } else {
                                response.sendRedirect("/login");
                            }
                        })
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
