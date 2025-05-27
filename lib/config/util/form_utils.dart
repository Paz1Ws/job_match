class FormUtils {
  // Helper to remove leading/trailing spaces and reduce multiple internal spaces to one
  static String clearSpaces(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  // Regex for email validation
  static final RegExp _emailRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  // Regex for password: min 6 chars, at least one letter and one number
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$',
  );

  // Regex for Peru phone number: 9 digits, starts with 9
  static final RegExp _peruPhoneRegExp = RegExp(r'^9\d{8}$');

  static String? validateEmailLogin(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) {
      return 'El correo electrónico es obligatorio.';
    }
    if (!_emailRegExp.hasMatch(value)) {
      return 'Por favor, introduce un correo electrónico válido.';
    }
    return null;
  }

  static String? validatePasswordLogin(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria.';
    }
    return null;
  }

  static String? validateEmailForSingUp(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) {
      return 'El correo electrónico es obligatorio.';
    }
    if (!_emailRegExp.hasMatch(value)) {
      return 'Por favor, introduce un correo electrónico válido.';
    }
    return null;
  }

  static String? validatePasswordForSingUp(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria.';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }
    if (!_passwordRegExp.hasMatch(value)) {
      return 'La contraseña debe contener letras y números.';
    }
    return null;
  }

  static String? validateName(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return 'El nombre es obligatorio.';
    if (value.length < 2) return 'El nombre debe tener al menos 2 caracteres.';
    if (value.length > 50)
      return 'El nombre no puede tener más de 50 caracteres.';
    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(value))
      return 'El nombre solo puede contener letras y espacios.';
    return null;
  }

  static String? validatePhone(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return 'El número de teléfono es obligatorio.';
    if (!_peruPhoneRegExp.hasMatch(value)) {
      return 'Introduce un número peruano válido (9 dígitos, empieza con 9).';
    }
    return null;
  }

  static String? validateCompanyPhone(String? value) {
    // For company (required)
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return 'El teléfono de la empresa es obligatorio.';
    if (!_peruPhoneRegExp.hasMatch(value)) {
      return 'Introduce un número válido (9 dígitos).';
    }
    return null;
  }

  static String? validateCity(String? value) {
    // Changed from validateAddress to be more specific
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return 'La ciudad es obligatoria.';
    if (value.length < 3) return 'La ciudad debe tener al menos 3 caracteres.';
    if (value.length > 100)
      return 'La ciudad no puede tener más de 100 caracteres.';
    return null;
  }

  static String? validateCountry(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor selecciona un país.';
    }
    return null;
  }

  static String? validateExperience(String? value) {
    if (value == null || value.isEmpty)
      return 'Por favor selecciona un nivel de experiencia.';
    return null;
  }

  static String? validateEducation(String? value) {
    if (value == null || value.isEmpty)
      return 'Por favor selecciona tu nivel educativo.';
    return null;
  }

  static String? validateWorkExperience(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty)
      return 'El resumen de experiencia laboral es obligatorio.';
    if (value.length < 50)
      return 'El resumen de experiencia laboral debe tener al menos 50 caracteres.';
    return null;
  }

  static String? validateSkillsSeparatedByCommas(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return 'Debes ingresar al menos una habilidad.';
    final skills =
        value.split(',').where((s) => clearSpaces(s).isNotEmpty).toList();
    if (skills.isEmpty) return 'Debes ingresar al menos una habilidad válida.';
    return null;
  }

  static String? validateBio(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return 'La biografía es obligatoria.';
    if (value.length < 50)
      return 'La biografía debe tener al menos 50 caracteres.';
    return null;
  }

  // Company specific validations
  static String? validateCompanyName(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return 'El nombre de la empresa es obligatorio.';
    if (value.length < 2)
      return 'El nombre de la empresa debe tener al menos 2 caracteres.';
    return null;
  }

  static String? validateIndustrySelected(String? value) {
    if (value == null || value.isEmpty)
      return 'Debes seleccionar una industria.';
    return null;
  }

  static String? validateCompanyDescription(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return 'La descripción de la empresa es obligatoria.';
    if (value.length < 100)
      return 'La descripción debe tener al menos 100 caracteres.';
    return null;
  }

  // General required field validation for dropdowns or simple text fields
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || clearSpaces(value).isEmpty) {
      return '$fieldName es obligatorio.';
    }
    return null;
  }
}
