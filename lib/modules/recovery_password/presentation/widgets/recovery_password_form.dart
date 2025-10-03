import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class RecoveryPasswordForm extends StatelessWidget {
  RecoveryPasswordForm({
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

  final _borderRadius = BorderRadius.circular(8.0);
  final _contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14);

  @override
  Widget build(BuildContext context) {
    final theme = GlobalTheme.of(context);
    
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: _buildForm(theme),
    );
  }

  Widget _buildForm(GlobalTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildNitField(theme),
        const SizedBox(height: 16),
        _buildEmailField(theme),
        const SizedBox(height: 24),
        _buildSubmitButton(theme),
      ],
    );
  }

  Widget _buildNitField(GlobalTheme theme) {
    return TextFormField(
      controller: nitController,
      focusNode: nitFocusNode,
      textInputAction: TextInputAction.next,
      style: _buildTextStyle(theme),
      decoration: _buildInputDecoration(
        theme: theme,
        label: 'NIT',
        prefixIcon: Icons.numbers,
      ),
      validator: nitValidator,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9-]')),
        LengthLimitingTextInputFormatter(20),
      ],
    );
  }

  Widget _buildEmailField(GlobalTheme theme) {
    return TextFormField(
      controller: emailController,
      focusNode: emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      style: _buildTextStyle(theme),
      decoration: _buildInputDecoration(
        theme: theme,
        label: 'Correo electrónico',
        prefixIcon: Icons.email,
      ),
      validator: emailValidator,
    );
  }

  InputDecoration _buildInputDecoration({
    required GlobalTheme theme,
    required String label,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: theme.bodyMedium.copyWith(
        color: theme.secondaryText,
      ),
      prefixIcon: Icon(prefixIcon, color: theme.secondaryText),
      border: _buildBorder(theme.secondaryText.withValues(alpha: 0.5)),
      enabledBorder: _buildBorder(theme.secondaryText.withValues(alpha: 0.5)),
      focusedBorder: _buildBorder(theme.primary, width: 1.5),
      errorBorder: _buildBorder(theme.error),
      focusedErrorBorder: _buildBorder(theme.error),
      filled: true,
      fillColor: theme.secondaryBackground,
      contentPadding: _contentPadding,
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
      borderRadius: _borderRadius,
    );
  }

  TextStyle _buildTextStyle(GlobalTheme theme) {
    return theme.bodyMedium.copyWith(
      color: theme.primaryText,
    );
  }

  Widget _buildSubmitButton(GlobalTheme theme) {
    return FFButtonWidget(
      onPressed: onResetPassword,
      text: 'Restablecer contraseña',
      options: FFButtonOptions(
        width: double.infinity,
        height: 50.0,
        color: theme.primary,
        textStyle: theme.titleSmall.copyWith(
          fontFamily: 'Manrope',
          color: theme.info,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0.0,
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }
}