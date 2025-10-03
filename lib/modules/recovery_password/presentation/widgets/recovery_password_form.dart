import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

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
      child: _buildFormContent(context),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNitField(context),
          const SizedBox(height: 20),
          _buildEmailField(context),
          const SizedBox(height: 20),
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  Widget _buildNitField(BuildContext context) {
    final theme = GlobalTheme.of(context);
    
    return TextFormField(
      controller: nitController,
      focusNode: nitFocusNode,
      textInputAction: TextInputAction.next,
      decoration: _buildInputDecoration(
        context,
        label: 'Ingrese el Nit',
        prefixIcon: Icons.numbers,
      ),
      style: _buildTextStyle(theme),
      validator: nitValidator,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9-]'))],
    );
  }

  Widget _buildEmailField(BuildContext context) {
    final theme = GlobalTheme.of(context);
    
    return TextFormField(
      controller: emailController,
      focusNode: emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      decoration: _buildInputDecoration(
        context,
        label: 'Correo electrónico',
        prefixIcon: Icons.email,
      ),
      style: _buildTextStyle(theme),
      validator: emailValidator,
    );
  }

  InputDecoration _buildInputDecoration(
    BuildContext context, {
    required String label,
    required IconData prefixIcon,
  }) {
    final theme = GlobalTheme.of(context);
    
    return InputDecoration(
      labelText: label,
      labelStyle: theme.bodyMedium?.copyWith(
        fontFamily: 'Manrope',
        color: theme.secondaryText,
        fontSize: 15.0,
        letterSpacing: 0.0,
      ),
      prefixIcon: Icon(prefixIcon, color: theme.secondaryText),
      enabledBorder: _buildBorder(theme.alternate),
      focusedBorder: _buildBorder(theme.primary, width: 1.5),
      errorBorder: _buildBorder(Colors.red),
      focusedErrorBorder: _buildBorder(Colors.red, width: 1.5),
      filled: true,
      fillColor: theme.primaryBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
      borderRadius: BorderRadius.circular(8.0),
    );
  }

  TextStyle _buildTextStyle(GlobalTheme theme) {
    return theme.bodyMedium?.copyWith(
      fontFamily: 'Manrope',
      letterSpacing: 0.0,
    ) ?? const TextStyle();
  }

  Widget _buildSubmitButton(BuildContext context) {
    final theme = GlobalTheme.of(context);
    
    return FFButtonWidget(
      onPressed: onResetPassword,
      text: 'Restablecer contraseña',
      options: FFButtonOptions(
        width: double.infinity,
        height: 50.0,
        color: theme.primary,
        textStyle: theme.titleSmall?.copyWith(
          fontFamily: 'Manrope',
          color: theme.info,
          letterSpacing: 0.0,
        ) ?? const TextStyle(),
        elevation: 0.0,
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }
}