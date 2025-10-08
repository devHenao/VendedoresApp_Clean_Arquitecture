import 'package:flutter/material.dart';
import 'package:app_vendedores/modules/auth/infrastructure/services/auth_util.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MenuController extends ChangeNotifier {
  final BuildContext _context;

  MenuController(this._context);

  Future<void> signOut() async {
    try {
      FFAppState().resetAppState();

      await Future.delayed(const Duration(milliseconds: 100));

      await authManager.signOut();

      _navigateToLogin();
    } catch (e) {
      debugPrint('Error during sign out: $e');
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    if ((_context as Element).mounted) {
      Navigator.of(_context, rootNavigator: true).pushNamedAndRemoveUntil(
        '/Login',
        (route) => false,
      );
    }
  }
}
