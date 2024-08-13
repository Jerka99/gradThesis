package com.example.demo.Auth.controllers;
import com.example.demo.Auth.services.UserService;
import com.example.demo.Auth.entities.User;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.access.prepost.PreAuthorize;

import java.util.List;

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
                .role(currentUser.getRole())
                .email(currentUser.getEmail())
                .id(currentUser.getId())
                .build();

        return ResponseEntity.ok(user);
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ROLE_ADMIN')") //https://developer.okta.com/blog/2019/06/20/spring-preauthorize
    public ResponseEntity<List<User>> allUsers() {
        List <User> users = userService.allUsers();

        return ResponseEntity.ok(users);
    }
}
