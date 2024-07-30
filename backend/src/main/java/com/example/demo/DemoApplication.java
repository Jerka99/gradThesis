package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;

import java.security.SecureRandom;
import java.util.Base64;

@SpringBootApplication
@EnableWebSecurity(debug = true)
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
//		SecureRandom secureRandom = new SecureRandom();
//		byte[] key = new byte[32]; // 256 bits / 32 bytes
//		secureRandom.nextBytes(key);
//		String base64Key = Base64.getEncoder().encodeToString(key);
//		System.out.println("Base64 Encoded Key: " + base64Key);

	}

}
