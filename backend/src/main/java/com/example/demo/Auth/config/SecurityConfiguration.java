package com.example.demo.Auth.config;

import lombok.AllArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
@AllArgsConstructor
@EnableWebSecurity
public class SecurityConfiguration {
    private final AuthenticationProvider authenticationProvider;
    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http.csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(
                        auth -> auth.requestMatchers("/auth/**")
                                .permitAll()
                                .anyRequest()
                                .authenticated())//allows request without authentication login and register
                .sessionManagement(
                        sess -> sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                )//Without Server-Side Sessions: The server does not store any session data.
                // Each request from the client must contain all the necessary information to authenticate and authorize the user.
                //JWT (JSON Web Tokens): This is a common method for implementing stateless
                // authentication. Each request from the client includes a token (usually in
                // the Authorization header) that contains the user's authentication and authorization information.
                // The request is stateless, meaning every request must be treated as a new
                // one, even if it comes from the same client or has been received earlier.
                .authenticationProvider(authenticationProvider)
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();

        configuration.setAllowedOrigins(List.of("http://localhost:51970"));
        configuration.setAllowedMethods(List.of("GET","POST"));
        configuration.setAllowedHeaders(List.of("Authorization","Content-Type"));
//In summary, the corsConfigurationSource method defines a CORS configuration and applies it to
// all URL patterns (/**). The UrlBasedCorsConfigurationSource instance (source) is the main
// component that Spring Security uses to apply CORS settings to incoming requests
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();

        source.registerCorsConfiguration("/**",configuration);

        return source;
    }
}
