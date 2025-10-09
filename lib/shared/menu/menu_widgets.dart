import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MenuItems extends StatelessWidget {
  const MenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            thickness: 2.0,
            color: GlobalTheme.of(context).alternate,
          ),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.users,
            text: 'Clientes',
            onTap: () => context.pushNamed('Clientes'),
          ),
          _buildMenuItem(
            context,
            icon: Icons.inventory,
            text: 'Productos',
            onTap: () {
              if (context.read<FFAppState>().dataCliente.email.isNotEmpty) {
                context.pushNamed('Productos');
              } else {
                showDialog(
                  context: context,
                  builder: (alertDialogContext) {
                    final colors = GlobalTheme.of(context);
                    return AlertDialog(
                      backgroundColor: colors.secondaryBackground,
                      title: Text('¡Espera!', style: colors.headlineSmall),
                      content: Text(
                        'Por favor, selecciona un cliente para acceder a los productos.',
                        style: colors.bodyMedium,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(alertDialogContext),
                          child: Text('Ok', style: colors.bodyMedium.copyWith(color: colors.primary)),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.cartShopping,
            text: 'Mi carrito',
            onTap: () => context.pushNamed('Carrito'),
          ),
          Divider(
            thickness: 2.0,
            color: GlobalTheme.of(context).alternate,
          ),
        ].divide(const SizedBox(height: 35.0)),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            FaIcon(
              icon,
              color: GlobalTheme.of(context).primary,
              size: 24.0,
            ),
            const SizedBox(width: 20.0),
            Text(
              text,
              style: GlobalTheme.of(context).bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class MenuActions extends StatelessWidget {
  const MenuActions({super.key, required this.onSignOut});

  final VoidCallback onSignOut;

  void _toggleTheme(BuildContext context) {
    final currentTheme = Theme.of(context).brightness;
    final newTheme = currentTheme == Brightness.dark 
        ? ThemeMode.light 
        : ThemeMode.dark;
    setDarkModeSetting(context, newTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Botón de cambio de tema
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => _toggleTheme(context),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Theme.of(context).brightness == Brightness.dark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  color: GlobalTheme.of(context).primaryText,
                  size: 24.0,
                ),
                const SizedBox(width: 12.0),
                Text(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'Modo Claro'
                      : 'Modo Oscuro',
                  style: GlobalTheme.of(context).bodyLarge.override(
                        fontFamily: 'Manrope',
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onSignOut,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: GlobalTheme.of(context).error,
                  size: 24.0,
                ),
                const SizedBox(width: 12.0),
                Text(
                  'Salir',
                  style: GlobalTheme.of(context).bodyLarge.copyWith(
                        color: GlobalTheme.of(context).error,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MenuFooter extends StatelessWidget {
  const MenuFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 0.99),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Copyright  2024 © by Ofima S.A.S',
            style: GlobalTheme.of(context).bodySmall.copyWith(
                  color: GlobalTheme.of(context).secondaryText,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            'v.1.0.0.0',
            style: GlobalTheme.of(context).bodySmall.copyWith(
                  color: GlobalTheme.of(context).secondaryText,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final ffAppState = context.watch<FFAppState>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 10.0, 16.0, 0.0),
          child: Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              color: GlobalTheme.of(context).accent2,
              borderRadius: BorderRadius.circular(60.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60.0),
              child: Image.asset(
                'assets/images/logoOfimaAdsC2.png',
                width: 120.0,
                height: 120.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: GlobalTheme.of(context).secondaryBackground,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.person,
                  color: GlobalTheme.of(context).primary,
                  size: 24.0,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vendedor:',
                      style: GlobalTheme.of(context).bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      ffAppState.infoSeller.nameVenden.isNotEmpty
                          ? ffAppState.infoSeller.nameVenden
                          : 'Cargando...',
                      style: GlobalTheme.of(context).bodyMedium,
                    ),
                  ],
                ),
              ].divide(const SizedBox(width: 10.0)),
            ),
          ),
        ),
      ],
    );
  }
}
