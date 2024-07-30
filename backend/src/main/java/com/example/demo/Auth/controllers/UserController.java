package com.example.demo.Auth.controllers;
import com.example.demo.Auth.services.UserService;
import com.example.demo.User.Role;
import com.example.demo.User.User;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.access.prepost.PreAuthorize;

import java.util.List;
import java.util.Set;

@RequestMapping("/users")
@RestController
public class UserController {
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/me")
    @PreAuthorize("isAuthenticated()")//https://docs.spring.io/spring-security/reference/servlet/authentication/architecture.html#servlet-authentication-authentication
    public ResponseEntity<User> authenticatedUser() {
        //related to AuthenticationManager
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        User currentUser = (User) authentication.getPrincipal();

        User user = User.builder()
                .name(currentUser.getName())
                .roles(currentUser.getRoles())
                .email(currentUser.getEmail())
                .id(currentUser.getId())
                .build();

        return ResponseEntity.ok(user);
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ROLE_ADMIN')")
    public ResponseEntity<List<User>> allUsers() {
        List <User> users = userService.allUsers();

        return ResponseEntity.ok(users);
    }
}
