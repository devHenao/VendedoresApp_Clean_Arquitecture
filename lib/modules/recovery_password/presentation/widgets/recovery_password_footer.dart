import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RecoveryPasswordFooter extends StatelessWidget {
  const RecoveryPasswordFooter({super.key, required this.onGoToLogin});

  final VoidCallback onGoToLogin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '¿Recuerdas tu contraseña?',
            style: GlobalTheme.of(context).bodySmall.override(
                  fontFamily: 'Manrope',
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: onGoToLogin,
            child: Text(
              'Iniciar sesión',
              style: GlobalTheme.of(context).bodySmall.override(
                    fontFamily: 'Manrope',
                    color: GlobalTheme.of(context).primary,
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    decoration: TextDecoration.underline,
                  ),
            ),
          ),
        ].divide(const SizedBox(width: 10.0)),
      ),
    );
  }
}
