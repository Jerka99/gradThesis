package com.example.demo.Auth.services;
import com.example.demo.Auth.repository.UserRepository;
import com.example.demo.Auth.entities.User;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;

@Service
public class UserService {
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public List<User> allUsers() {

        List<User> users = new ArrayList<>(userRepository.findAll());

        return users;
    }
}
