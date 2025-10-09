import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class RecoveryPasswordFooter extends StatelessWidget {
  const RecoveryPasswordFooter({
    super.key, 
    required this.onGoToLogin,
  });

  final VoidCallback onGoToLogin;

  @override
  Widget build(BuildContext context) {
    final theme = GlobalTheme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '¿Recuerdas tu contraseña?',
            style: theme.bodySmall.copyWith(
              color: theme.secondaryText,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onGoToLogin,
            child: Text(
              'Iniciar sesión',
              style: theme.bodySmall.copyWith(
                color: theme.primary,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
