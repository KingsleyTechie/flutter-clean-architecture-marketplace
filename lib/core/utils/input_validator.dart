import '../errors/failures.dart';

class InputValidator {
  static ValidationFailure? validateEmail(String email) {
    if (email.isEmpty) {
      return ValidationFailure('Email is required');
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    
    if (!emailRegex.hasMatch(email)) {
      return ValidationFailure('Please enter a valid email');
    }
    
    return null;
  }
  
  static ValidationFailure? validatePassword(String password) {
    if (password.isEmpty) {
      return ValidationFailure('Password is required');
    }
    
    if (password.length < 8) {
      return ValidationFailure('Password must be at least 8 characters');
    }
    
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return ValidationFailure('Password must contain at least one uppercase letter');
    }
    
    if (!password.contains(RegExp(r'[a-z]'))) {
      return ValidationFailure('Password must contain at least one lowercase letter');
    }
    
    if (!password.contains(RegExp(r'[0-9]'))) {
      return ValidationFailure('Password must contain at least one number');
    }
  
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return ValidationFailure('Password must contain at least one special character');
    }
    
    return null;
  }
  
  static ValidationFailure? validatePhoneNumber(String phone) {
    if (phone.isEmpty) {
      return ValidationFailure('Phone number is required');
    }
    
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    
    if (!phoneRegex.hasMatch(phone)) {
      return ValidationFailure('Please enter a valid phone number');
    }
    
    return null;
  }
  
  static ValidationFailure? validateRequired(String value, String fieldName) {
    if (value.isEmpty) {
      return ValidationFailure('$fieldName is required');
    }
    
    return null;
  }
  
  static ValidationFailure? validateConfirmPassword(
    String password,
    String confirmPassword,
  ) {
    final passwordValidation = validatePassword(password);
    if (passwordValidation != null) {
      return passwordValidation;
    }
    
    if (password != confirmPassword) {
      return ValidationFailure('Passwords do not match');
    }
    
    return null;
  }
}
