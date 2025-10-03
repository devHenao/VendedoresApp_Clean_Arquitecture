import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class RecoveryPasswordForm extends StatefulWidget {
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
  State<RecoveryPasswordForm> createState() => _RecoveryPasswordFormState();
}

class _RecoveryPasswordFormState extends State<RecoveryPasswordForm> {
  bool _isFormSubmitted = false;

  final _borderRadius = BorderRadius.circular(8.0);
  final _contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14);

  @override
  Widget build(BuildContext context) {
    final theme = GlobalTheme.of(context);
    
    return Form(
      key: widget.formKey,
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
      controller: widget.nitController,
      focusNode: widget.nitFocusNode,
      textInputAction: TextInputAction.next,
      style: _buildTextStyle(theme),
      decoration: _buildInputDecoration(
        theme: theme,
        label: 'NIT',
        prefixIcon: Icons.numbers,
        errorText: _getNitErrorText(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese el NIT';
        }
        return widget.nitValidator?.call(value);
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9-]')),
        LengthLimitingTextInputFormatter(20),
      ],
    );
  }

  String? _getNitErrorText() {
    if (!_isFormSubmitted) return null;
    final value = widget.nitController.text;
    if (value.isEmpty) {
      return 'Por favor ingrese el NIT';
    }
    return widget.nitValidator?.call(value);
  }

  Widget _buildEmailField(GlobalTheme theme) {
    return TextFormField(
      controller: widget.emailController,
      focusNode: widget.emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      style: _buildTextStyle(theme),
      decoration: _buildInputDecoration(
        theme: theme,
        label: 'Correo electrónico',
        prefixIcon: Icons.email,
        errorText: _getEmailErrorText(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo es obligatorio';
        }
        if (!value.contains('@') || !value.contains('.')) {
          return 'Ingrese un correo electrónico válido';
        }
        return widget.emailValidator?.call(value);
      },
    );
  }

  String? _getEmailErrorText() {
    if (!_isFormSubmitted) return null;
    final value = widget.emailController.text;
    if (value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return widget.emailValidator?.call(value);
  }

  InputDecoration _buildInputDecoration({
    required GlobalTheme theme,
    required String label,
    required IconData prefixIcon,
    String? errorText,
  }) {
    final hasError = errorText != null && errorText.isNotEmpty;
    
    return InputDecoration(
      labelText: label,
      labelStyle: theme.bodyMedium.copyWith(
        color: hasError ? theme.error : theme.secondaryText,
      ),
      prefixIcon: Icon(
        prefixIcon, 
        color: hasError ? theme.error : theme.secondaryText,
      ),
      border: _buildBorder(hasError ? theme.error : theme.secondaryText.withValues(alpha: 0.5)),
      enabledBorder: _buildBorder(hasError ? theme.error : theme.secondaryText.withValues(alpha: 0.5)),
      focusedBorder: _buildBorder(hasError ? theme.error : theme.primary, width: 1.5),
      errorBorder: _buildBorder(theme.error, width: 1.0),
      focusedErrorBorder: _buildBorder(theme.error, width: 1.5),
      filled: true,
      fillColor: theme.secondaryBackground,
      contentPadding: _contentPadding,
      errorText: hasError ? errorText : null,
      errorStyle: theme.bodySmall.copyWith(
        color: theme.error,
        height: 1.0,
      ),
      errorMaxLines: 2,
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
      onPressed: () {
        setState(() {
          _isFormSubmitted = true;
        });
        
        if (widget.formKey.currentState?.validate() ?? false) {
          widget.onResetPassword();
        }
      },
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