package com.example.demo.Auth.exceptions;
import java.util.regex.Pattern;

public class InputValidator {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$");
    private static final Pattern PASSWORD_PATTERN = Pattern.compile("^(?=\\S+$).{6,}$");
    private static final Pattern NAME_PATTERN = Pattern.compile("^[a-zA-Z0-9]{3,}$");

    public void validateEmail(String email) {
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            throw new RegexValidationException("Invalid email format");
        }
    }

    public void validatePassword(String password) {
        if (!PASSWORD_PATTERN.matcher(password).matches()) {
            throw new RegexValidationException("Password must be 6+ characters, with no spaces.");
        }
    }

    public void validateName(String password) {
        if (!NAME_PATTERN.matcher(password).matches()) {
            throw new RegexValidationException("Name must contain min 3 characters.");
        }
    }

}
