import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class RecoveryPasswordHeader extends StatelessWidget {
  const RecoveryPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = GlobalTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Has olvidado tu contraseña?',
          style: theme.headlineMedium.copyWith(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            color: theme.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ingrese su NIT y dirección de correo electrónico para restablecer su contraseña.',
          style: theme.bodyLarge.copyWith(
            fontFamily: 'Manrope',
            color: theme.secondaryText,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
