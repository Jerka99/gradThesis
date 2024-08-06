package com.example.demo.Auth.entities;

import com.example.demo.Auth.repository.RoleRepository;
import jakarta.annotation.PostConstruct;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Arrays;

@Component
@AllArgsConstructor
public class RoleInitializer {

//    @Autowired
    private RoleRepository roleRepository;

    @PostConstruct
    public void initRoles() {
        if (roleRepository.count() == 0) {
            Arrays.asList("DRIVER", "CUSTOMER", "ADMIN").forEach(roleName -> {
                Role role = new Role();
                role.setName(roleName);
                roleRepository.save(role);
            });
        }
    }
}
