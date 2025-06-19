package com.example.corrige_gabarito.java.security;


import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) throws Exception {
        return httpSecurity
                .csrf(AbstractHttpConfigurer::disable)
                .cors(Customizer.withDefaults())
                .headers(header -> header.frameOptions(config -> config.sameOrigin()))
                .httpBasic(Customizer.withDefaults())
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/images/**",
                                "/css/**", "/error/**").permitAll()
                        .requestMatchers("/**","/login").permitAll()
                        .requestMatchers("/banco/**", "/usuarios/**").hasRole("ADMIN")
                        .requestMatchers("/api/**").hasAnyRole("ADMIN", "PROFESSOR", "ALUNO", "API")
                        .anyRequest().authenticated()
                ).formLogin(login -> login
                        .loginPage("/login")
                        .defaultSuccessUrl("/",true))
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login"))
                .build();
    }

    @Bean
    public UserDetailsService userDetailsService() {

        UserDetails professor =
                User.withDefaultPasswordEncoder()
                        .username("professor")
                        .password(new BCryptPasswordEncoder().encode("professor"))
                        .roles("professor")
                        .build();

        UserDetails aluno =
                User.withDefaultPasswordEncoder()
                        .username("aluno")
                        .password(new BCryptPasswordEncoder().encode("aluno"))
                        .roles("aluno")
                        .build();


        return new InMemoryUserDetailsManager(professor, aluno);
    }

    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }

}
