class FormUtils {
  static String clearSpaces(String value) => value.trim().replaceAll(RegExp(r'\s+'), ' ');
  
  static String? validateEmailLogin(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return 'El email es obligatorio';
    return null;
  }

  static String? validatePasswordLogin(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return 'La contraseña es obligatoria';
    return null;
  }
}