extension StringExtension on String {
  String authReturn() {
    return "${this[0].toUpperCase()}${this.substring(1)}".replaceAll('-', ' ');
  }
}
final String passwordRegex = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';

enum ValidationError {
  isRequired,
  invalidEmail,
  shortPassword,
  weakPassword,
}

String returnValidationError(ValidationError validationError){
  switch(validationError) {
    case ValidationError.isRequired:
      return 'Pole jest wymagane';
    case ValidationError.invalidEmail:
      return 'Podaj poprany email';
    case ValidationError.shortPassword:
      return 'Hasło musi zaweirać przynajmniej 6 znaków';
    case ValidationError.weakPassword:
      return 'Hasło musi zawierać: małą literę, dużą literę, cyfrę, znak specjalny';
    default:
      return 'Nieoblużony przypadek';
  }
}