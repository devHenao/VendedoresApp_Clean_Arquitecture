import 'package:flutter/material.dart';
import 'package:app_vendedores/modules/auth/infrastructure/services/auth_util.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MenuController extends ChangeNotifier {
  final BuildContext _context;

  MenuController(this._context);

  Future<void> signOut() async {
    try {
      // Limpiar el estado de la aplicación
      FFAppState().resetAppState();

      // Pequeña pausa para asegurar actualizaciones de UI
      await Future.delayed(const Duration(milliseconds: 100));

      // Realizar operaciones de cierre de sesión
      await authManager.signOut();

      // Navegar al login
      _navigateToLogin();
    } catch (e) {
      debugPrint('Error during sign out: $e');
      // Navegar al login incluso si hay un error
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    // Usamos el contexto guardado para navegar.
    // Es importante verificar si el widget que proveyó el contexto sigue montado.
    if ((_context as Element).mounted) {
      Navigator.of(_context, rootNavigator: true).pushNamedAndRemoveUntil(
        '/Login',
        (route) => false,
      );
    }
  }
}
