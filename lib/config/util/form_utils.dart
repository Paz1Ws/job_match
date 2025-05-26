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


  static String? validateEmailForSingUp(String? value) {
    value = clearSpaces(value ?? '');
    if(validateEmailLogin(value) != null) return validateEmailLogin(value);
    if(!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) return 'El email no es válido';
    return null;
  }

  static String? validatePasswordForSingUp(String? value) {
    value = clearSpaces(value ?? '');
    if (validatePasswordLogin(value) != null) return validatePasswordLogin(value);
    if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
    if (value.length > 20) return 'La contraseña no puede tener más de 20 caracteres';
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{6,20}$').hasMatch(value)) {
      return 'La contraseña debe contener al menos una letra mayúscula, una minúscula y un número';
    }
    return null;
  }

  static String? validateName(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return 'El nombre es obligatorio';
    if (value.length < 2) return 'El nombre debe tener al menos 2 caracteres';
    if (value.length > 50) return 'El nombre no puede tener más de 50 caracteres';
    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(value)) return 'El nombre solo puede contener letras y espacios';
    return null;
  }

  static String? validatePhone(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return null;
    if (value.length < 7) return 'El teléfono debe tener al menos 7 dígitos';
    if (value.length > 15) return 'El teléfono no puede tener más de 15 dígitos';
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'El teléfono solo puede contener números';
    return null;
  }

  static String? validateCompanyPhone(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return 'El teléfono de la empresa es obligatorio';
    if (value.length < 7) return 'El teléfono de la empresa debe tener al menos 7 dígitos';
    if (value.length > 15) return 'El teléfono de la empresa no puede tener más de 15 dígitos';
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'El teléfono de la empresa solo puede contener números';
    return null;
  }

  static String? validateAddress(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return 'La dirección es obligatoria';
    if (value.length < 5) return 'La dirección debe tener al menos 5 caracteres';
    if (value.length > 100) return 'La dirección no puede tener más de 100 caracteres';
    return null;
  }

  static String? validateExperience(String? value) {
    if (value == null || value.isEmpty) return 'Por favor selecciona un nivel de experiencia';
    return null;
  }

  static String? validateEducation(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return 'Por favor ingresa tu nivel educativo';
    if (value.length < 2) return 'El nivel educativo debe tener al menos 2 caracteres';
    if (value.length > 50) return 'El nivel educativo no puede tener más de 50 caracteres';
    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(value)) return 'El nivel educativo solo puede contener letras y espacios';
    return null;
  }

  static String? validateWorkExperience(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return 'Por favor ingresa tu experiencia laboral';
    if (value.length < 5) return 'La experiencia laboral debe tener al menos 5 caracteres';
    if (value.length > 200) return 'La experiencia laboral no puede tener más de 200 caracteres';
    return null;
  }

  static String? validateUrlCv(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return null;
    if (!RegExp(r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$').hasMatch(value)) return 'La URL del CV no es válida';
    return null;
  }

  static String? validateSkillsSeparatedByCommas(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return 'Por favor ingresa al menos una habilidad';
    if (value.length < 2) return 'Cada habilidad debe tener al menos 2 caracteres';
    if (value.length > 200) return 'Las habilidades no pueden tener más de 200 caracteres en total';
    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s,]+$').hasMatch(value)) return 'Las habilidades solo pueden contener letras, espacios y comas';
    return null;
  }

  static String? validateBio(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return 'Por favor ingresa una breve biografía';
    if (value.length < 10) return 'La biografía debe tener al menos 10 caracteres';
    if (value.length > 500) return 'La biografía no puede tener más de 500 caracteres';
    return null;
  }

  static String? validateCompanyName(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return 'El nombre de la empresa es obligatorio';
    if (value.length < 2) return 'El nombre de la empresa debe tener al menos 2 caracteres';
    if (value.length > 50) return 'El nombre de la empresa no puede tener más de 50 caracteres';
    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(value)) return 'El nombre de la empresa solo puede contener letras y espacios';
    return null;
  }

  static String? validateIndustrySelected(String? value) {
    if (value == null || value.isEmpty) return 'Por favor selecciona una industria';
    return null;
  }

  static String? validateCompanyDescription(String? value) {
    value = clearSpaces(value ?? '');
    if (value.isEmpty) return 'La descripción de la empresa es obligatoria';
    if (value.length < 10) return 'La descripción de la empresa debe tener al menos 10 caracteres';
    if (value.length > 500) return 'La descripción de la empresa no puede tener más de 500 caracteres';
    return null;
  }
}