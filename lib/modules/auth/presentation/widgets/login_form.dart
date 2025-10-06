import 'package:app_vendedores/core/theme/theme.dart';
import 'package:app_vendedores/core/validations/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_vendedores/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:app_vendedores/modules/auth/presentation/bloc/auth_event.dart';
import 'package:app_vendedores/modules/auth/presentation/bloc/auth_state.dart';
import 'package:app_vendedores/modules/recovery_password/presentation/pages/recovery_password_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? false;
    
    if (rememberMe) {
      final nitId = prefs.getString('remembered_nit_id') ?? '';
      final email = prefs.getString('remembered_email') ?? '';
      final password = prefs.getString('remembered_password') ?? '';
      
      if (mounted) {
        setState(() {
          _identificationController.text = nitId;
          _emailController.text = email;
          _passwordController.text = password;
          _rememberMe = true;
        });
      }
    }
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('remembered_nit_id', _identificationController.text);
    await prefs.setString('remembered_email', _emailController.text);
    await prefs.setString('remembered_password', _passwordController.text);
    await prefs.setBool('remember_me', true);
  }

  Future<void> _clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('remembered_nit_id');
    await prefs.remove('remembered_email');
    await prefs.remove('remembered_password');
    await prefs.setBool('remember_me', false);
  }

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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return AbsorbPointer(
          absorbing: isLoading,
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: globalTheme.secondaryBackground,
                body: _buildBody(),
              ),
              if (isLoading)
                Container(
                  color: Colors.black54, // Semi-transparent black overlay
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3.0,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
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
      validator: (value) => AppValidators.validateNitOrId(value),
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
      validator: (value) => AppValidators.validateEmail(value),
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
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: globalTheme.secondaryText,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (value) => AppValidators.validatePassword(value),
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
                  child: RecoveryPasswordDialog(),
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
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Save credentials if remember me is checked
      if (_rememberMe) {
        _saveCredentials();
      } else {
        _clearCredentials();
      }
      
      context.read<AuthBloc>().add(
            LoginButtonPressed(
              identification: _identificationController.text,
              email: _emailController.text,
              password: _passwordController.text,
              rememberMe: _rememberMe,
            ),
          );
    }
  }
}
