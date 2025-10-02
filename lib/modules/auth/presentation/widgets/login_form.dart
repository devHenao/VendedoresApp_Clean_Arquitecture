import 'package:app_vendedores/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_vendedores/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:app_vendedores/modules/auth/presentation/bloc/auth_event.dart';
import 'package:app_vendedores/modules/auth/presentation/bloc/auth_state.dart';
import 'package:app_vendedores/modules/auth/presentation/widgets/recovery_password/recovery_password_widget.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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

  // Logo y encabezado
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

  // Texto de bienvenida
  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        // Título centrado
        Align(
          alignment: Alignment.center,
          child: Text(
            'Vendedores',
            style: GlobalTheme.of(context).bodyMedium.override(
                  fontFamily: 'Work Sans',
                  fontSize: 50.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Bienvenidos',
          style: GoogleFonts.roboto(
            fontSize: 24,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Acceso al Sistema',
          style: GoogleFonts.roboto(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // Campos del formulario
  Widget _buildFormFields() {
    return Column(
      children: [
        _buildNitField(),
        const SizedBox(height: 16),
        _buildEmailField(),
        const SizedBox(height: 16),
        _buildPasswordField(),
        const SizedBox(height: 16),
        _buildRememberAndForgot(),
      ],
    );
  }

  // Campo NIT/ID
  Widget _buildNitField() {
    final theme = Theme.of(context);
    return TextFormField(
      controller: _identificationController,
      decoration: InputDecoration(
        labelText: 'Ingrese el Nit...',
        border: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: theme.primaryColor, width: 2.0),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: _contentPadding,
      ),
      style: GoogleFonts.roboto(fontSize: 16),
      validator: (value) =>
          value?.isEmpty ?? true ? 'Por favor ingrese su NIT/ID' : null,
    );
  }

  // Campo Email
  Widget _buildEmailField() {
    final theme = Theme.of(context);
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Ingrese su email aquí...',
        border: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: theme.primaryColor, width: 2.0),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: _contentPadding,
      ),
      keyboardType: TextInputType.emailAddress,
      style: GoogleFonts.roboto(fontSize: 16),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Por favor ingrese su email';
        if (!value.contains('@')) return 'Ingrese un email válido';
        return null;
      },
    );
  }

  // Campo Contraseña
  Widget _buildPasswordField() {
    final theme = Theme.of(context);
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Ingrese su contraseña aquí...',
        border: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: theme.primaryColor, width: 2.0),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: _contentPadding,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      obscureText: _obscurePassword,
      style: GoogleFonts.roboto(fontSize: 16),
      validator: (value) {
        if (value == null || value.isEmpty)
          return 'Por favor ingrese su contraseña';
        if (value.length < 4)
          return 'La contraseña debe tener al menos 4 caracteres';
        return null;
      },
    );
  }

  // Recordar contraseña y olvidé mi contraseña
  Widget _buildRememberAndForgot() {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Recordarme
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) =>
                  setState(() => _rememberMe = value ?? false),
              side: BorderSide(color: Colors.grey[600]!),
              fillColor: MaterialStateProperty.resolveWith<Color>(
                (states) => states.contains(MaterialState.selected)
                    ? theme.primaryColor
                    : Colors.white,
              ),
            ),
            Text(
              'Recordarme',
              style: GlobalTheme.of(context).bodyMedium.override(
                    fontFamily: 'Manrope',
                    color: GlobalTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
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
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: theme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // Botón de inicio de sesión
  Widget _buildLoginButton() {
    final theme = Theme.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state is AuthLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: _borderRadius),
          ),
          child: state is AuthLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Iniciar Sesión',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        );
      },
    );
  }

  // Manejador del inicio de sesión
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
