import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class RecoveryPasswordHeader extends StatelessWidget {
  const RecoveryPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Has olvidado tu contraseña?',
          style: GlobalTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          'Ingrese su dirección de correo electrónico y le enviaremos instrucciones para restablecer su contraseña.',
          textAlign: TextAlign.justify,
          style: GlobalTheme.of(context).bodyLarge.override(
                fontFamily: 'Manrope',
                color: GlobalTheme.of(context).secondaryText,
                fontSize: 18.0,
                letterSpacing: 0.0,
              ),
        ),
      ],
    );
  }
}
