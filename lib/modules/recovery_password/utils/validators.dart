class RecoveryPasswordValidators {
  static String? validateNit(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese el NIT';
    }
    // Aquí puedes agregar más validaciones específicas para el NIT si es necesario
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese el correo electrónico';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Ingrese un correo electrónico válido';
    }
    // Aquí puedes agregar más validaciones de formato de correo si es necesario
    return null;
  }
}
