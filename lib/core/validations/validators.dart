class AppValidators {
  static String? validateNitOrId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su NIT/ID';
    }
    return null;
  }

  static String? validateNit(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese el NIT';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese el correo electrónico';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Ingrese un correo electrónico válido';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su contraseña';
    }
    if (value.length < 4) {
      return 'La contraseña debe tener al menos 4 caracteres';
    }
    return null;
  }

  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese $fieldName';
    }
    return null;
  }
}
