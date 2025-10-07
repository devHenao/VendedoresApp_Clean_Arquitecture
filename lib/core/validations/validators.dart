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
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingrese $fieldName';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingrese el nombre';
    }
    if (value.trim().length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }
    return null;
  }

  static String? validateContact(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingrese el nombre de contacto';
    }
    
    if (value.trim().length < 3) {
      return 'El contacto debe tener al menos 3 caracteres';
    }
    
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingrese el número de teléfono';
    }
    if (!RegExp(r'^[0-9+\- ]+$').hasMatch(value)) {
      return 'Ingrese un número de teléfono válido';
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingrese la dirección';
    }
    if (value.trim().length < 5) {
      return 'La dirección debe tener al menos 5 caracteres';
    }
    return null;
  }

  static String? validateDepartment(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor seleccione un departamento';
    }
    return null;
  }

  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor seleccione una ciudad';
    }
    return null;
  }
}
