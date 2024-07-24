package com.example.demo.Auth.config;

import com.example.demo.Auth.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@AllArgsConstructor
@Configuration
public class ApplicationConfiguration {
    private final UserRepository userRepository;

    //When you define the UserDetailsService bean with a lambda expression, you are essentially providing
    // an implementation for the loadUserByUsername method.
    // Spring will manage this bean, and you can inject and use it wherever needed in your application.
    @Bean
    UserDetailsService userDetailsService() {
        return username -> userRepository.findByEmail(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
    }

    @Bean
    BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    //one of ProviderManagers instances is AuthenticationProvider, and it performs a specific
// type of authentication e.g. UsernamePasswordAuthenticationToken
    @Bean
    AuthenticationProvider authenticationProvider() {
        //AuthenticationProvider: This interface has a single method authenticate
        // (Authentication authentication) that attempts to authenticate the given Authentication object.
        //ProviderManager is the most commonly used implementation of AuthenticationManager. ProviderManager
        // delegates to a List of AuthenticationProvider instances

        //IMPORTANT
        //You can inject multiple AuthenticationProviders instances into ProviderManager. Each
        // AuthenticationProvider performs a specific type of authentication. For example,
        // DaoAuthenticationProvider supports username/password-based authentication, while
        // JwtAuthenticationProvider supports authenticating a JWT token.
//https://docs.spring.io/spring-security/reference/servlet/authentication/passwords/dao-authentication-provider.html#servlet-authentication-daoauthenticationprovider

        //AuthenticationManager is the API that defines how Spring Security’s Filters perform
        // authentication. The Authentication that is returned is then set on the SecurityContextHolder
        // by the controller (that is, by Spring Security’s Filters instances) that invoked the
        // AuthenticationManager. If you are integrating with Spring Security’s Filters instances
        // it is required to use an AuthenticationManager.
        // While the implementation of AuthenticationManager could be anything, the most common
        // implementation is ProviderManager.

        //DaoAuthenticationProvider is an AuthenticationProvider implementation that
        // uses a UserDetailsService and PasswordEncoder to authenticate a username and password.
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();

        authProvider.setUserDetailsService(userDetailsService());
        authProvider.setPasswordEncoder(passwordEncoder());

        return authProvider;
    }
}