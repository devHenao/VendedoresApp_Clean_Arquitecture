import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_util.dart';

import 'package:flutter/services.dart';

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

class RecoveryPasswordForm extends StatelessWidget {
  const RecoveryPasswordForm({
    super.key,
    required this.formKey,
    required this.nitController,
    required this.nitFocusNode,
    this.nitValidator,
    required this.emailController,
    required this.emailFocusNode,
    this.emailValidator,
    required this.onResetPassword,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nitController;
  final FocusNode nitFocusNode;
  final FormFieldValidator<String>? nitValidator;
  final TextEditingController emailController;
  final FocusNode emailFocusNode;
  final FormFieldValidator<String>? emailValidator;
  final VoidCallback onResetPassword;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nitController,
              focusNode: nitFocusNode,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Ingrese el Nit',
                labelStyle: GlobalTheme.of(context).bodyMedium.override(
                      fontFamily: 'Manrope',
                      color: GlobalTheme.of(context).secondaryText,
                      fontSize: 15.0,
                      letterSpacing: 0.0,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: GlobalTheme.of(context).alternate,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0x00000000), width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0x00000000), width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0x00000000), width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: GlobalTheme.of(context).primaryBackground,
              ),
              style: GlobalTheme.of(context).bodyMedium.override(
                    fontFamily: 'Manrope',
                    letterSpacing: 0.0,
                  ),
              validator: nitValidator,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9-]'))],
            ),
            TextFormField(
              controller: emailController,
              focusNode: emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                labelStyle: GlobalTheme.of(context).bodyMedium.override(
                      fontFamily: 'Manrope',
                      color: GlobalTheme.of(context).secondaryText,
                      fontSize: 15.0,
                      letterSpacing: 0.0,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: GlobalTheme.of(context).alternate,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0x00000000), width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0x00000000), width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0x00000000), width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: GlobalTheme.of(context).primaryBackground,
              ),
              style: GlobalTheme.of(context).bodyMedium.override(
                    fontFamily: 'Manrope',
                    letterSpacing: 0.0,
                  ),
              validator: emailValidator,
            ),
            FFButtonWidget(
              onPressed: onResetPassword,
              text: 'Restablecer contraseña',
              options: FFButtonOptions(
                width: double.infinity,
                height: 50.0,
                color: GlobalTheme.of(context).primary,
                textStyle: GlobalTheme.of(context).titleSmall.override(
                      fontFamily: 'Manrope',
                      color: GlobalTheme.of(context).info,
                      letterSpacing: 0.0,
                    ),
                elevation: 0.0,
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ].divide(const SizedBox(height: 20.0)),
        ),
      ),
    );
  }
}

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
