import 'package:app_vendedores/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_vendedores/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:app_vendedores/modules/auth/presentation/bloc/auth_event.dart';
import 'package:app_vendedores/modules/auth/presentation/bloc/auth_state.dart';
import 'package:app_vendedores/modules/recovery_password/recovery_password_widget.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _identificationController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePassword = true;

  final _borderRadius = BorderRadius.circular(8);
  final _contentPadding =
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14);

  @override
  void dispose() {
    _identificationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final globalTheme = GlobalTheme.of(context);
    return Scaffold(
      backgroundColor: globalTheme.secondaryBackground,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildLogoHeader(),
                _buildWelcomeText(),
                const SizedBox(height: 32),
                _buildFormFields(),
                const SizedBox(height: 24),
                _buildLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Column(
      children: [
        Align(
          alignment: const AlignmentDirectional(-0.05, 0.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/logoOfima.png',
                    width: 400.0,
                    height: 180.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(),
        const SizedBox(height: 30),
        _subtitle(),
        _subtitleText(),
      ],
    );
  }

  Widget _title() {
    final globalTheme = GlobalTheme.of(context);
    return Align(
      alignment: Alignment.topCenter,
      child: Text(
        'Vendedores',
        style: globalTheme.headlineMedium.copyWith(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: globalTheme.primaryText,
        ),
      ),
    );
  }

  Widget _subtitle() {
    final globalTheme = GlobalTheme.of(context);
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        'Bienvenido',
        style: globalTheme.headlineMedium.copyWith(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: globalTheme.primaryText,
        ),
      ),
    );
  }

  Widget _subtitleText() {
    final globalTheme = GlobalTheme.of(context);
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        'Acceso al Sistema',
        style: globalTheme.bodyLarge.copyWith(
          color: globalTheme.secondaryText,
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildNitField(),
        const SizedBox(height: 30),
        _buildEmailField(),
        const SizedBox(height: 30),
        _buildPasswordField(),
        const SizedBox(height: 30),
        _buildRememberAndForgot(),
      ],
    );
  }

  Widget _buildNitField() {
    final globalTheme = GlobalTheme.of(context);
    return TextFormField(
      controller: _identificationController,
      style: globalTheme.bodyMedium.copyWith(color: globalTheme.primaryText),
      decoration: InputDecoration(
        labelText: 'NIT/ID',
        labelStyle: globalTheme.labelMedium,
        prefixIcon: Icon(Icons.numbers, color: globalTheme.secondaryText),
        border: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide:
              BorderSide(color: globalTheme.secondaryText.withValues(alpha: 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide:
              BorderSide(color: globalTheme.secondaryText.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: globalTheme.primary, width: 1.5),
        ),
        filled: true,
        fillColor: globalTheme.secondaryBackground,
        contentPadding: _contentPadding,
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? 'Por favor ingrese su NIT/ID' : null,
    );
  }

  Widget _buildEmailField() {
    final globalTheme = GlobalTheme.of(context);
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: globalTheme.bodyMedium.copyWith(color: globalTheme.primaryText),
      decoration: InputDecoration(
        labelText: 'Correo electrónico',
        labelStyle: globalTheme.labelMedium,
        prefixIcon: Icon(Icons.email, color: globalTheme.secondaryText),
        border: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide:
              BorderSide(color: globalTheme.secondaryText.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide:
              BorderSide(color: globalTheme.secondaryText.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: globalTheme.primary, width: 1.5),
        ),
        filled: true,
        fillColor: globalTheme.secondaryBackground,
        contentPadding: _contentPadding,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Por favor ingrese su email';
        if (!value.contains('@')) return 'Ingrese un email válido';
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    final globalTheme = GlobalTheme.of(context);
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: globalTheme.bodyMedium.copyWith(color: globalTheme.primaryText),
      decoration: InputDecoration(
        labelText: 'Contraseña',
        labelStyle: globalTheme.labelMedium,
        prefixIcon: Icon(Icons.lock, color: globalTheme.secondaryText),
        border: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide:
              BorderSide(color: globalTheme.secondaryText.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide:
              BorderSide(color: globalTheme.secondaryText.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: globalTheme.primary, width: 1.5),
        ),
        filled: true,
        fillColor: globalTheme.secondaryBackground,
        contentPadding: _contentPadding,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: globalTheme.secondaryText,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty)
          return 'Por favor ingrese su contraseña';
        if (value.length < 4)
          return 'La contraseña debe tener al menos 4 caracteres';
        return null;
      },
    );
  }

  Widget _buildRememberAndForgot() {
    final globalTheme = GlobalTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Recordarme
        Row(
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: globalTheme.secondaryText,
              ),
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) =>
                    setState(() => _rememberMe = value ?? false),
                fillColor: WidgetStateProperty.resolveWith<Color>(
                  (states) => states.contains(WidgetState.selected)
                      ? globalTheme.primary
                      : globalTheme.secondaryBackground,
                ),
                side: BorderSide(color: globalTheme.secondaryText),
              ),
            ),
            Text(
              'Recordarme',
              style: globalTheme.labelMedium.copyWith(
                color: globalTheme.secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        // Olvidé mi contraseña
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: EdgeInsets.all(20),
                  child: RecoveryPasswordWidget(),
                );
              },
            );
          },
          child: Text(
            '¿Olvidó su contraseña?',
            style: globalTheme.labelMedium.copyWith(
              color: globalTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    final globalTheme = GlobalTheme.of(context);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(globalTheme.primary),
            ),
          );
        }

        return ElevatedButton(
          onPressed: _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: globalTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: _borderRadius,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 2,
          ),
          child: Text(
            'Iniciar Sesión',
            style: globalTheme.labelLarge.copyWith(
              color: globalTheme.info,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginButtonPressed(
              identification: _identificationController.text,
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }
}
