import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/flutter_flow/flutter_flow_theme.dart';
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
          const Divider(
            thickness: 2.0,
            color: Color(0xFFE0E3E7), // Reemplazado por un color explícito
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
                    return AlertDialog(
                      title: const Text('¡Espera!'),
                      content: const Text(
                          'Por favor, selecciona un cliente para acceder a los productos.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(alertDialogContext),
                          child: const Text('Ok'),
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
          const Divider(
            thickness: 2.0,
            color: Color(0xFFE0E3E7), // Reemplazado por un color explícito
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
              color: FlutterFlowTheme.of(context).primary,
              size: 24.0,
            ),
            const SizedBox(width: 20.0),
            Text(
              text,
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: 'Manrope',
                    letterSpacing: 0.0,
                  ),
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onSignOut,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              Icons.logout_rounded,
              color: FlutterFlowTheme.of(context).error,
              size: 24.0,
            ),
            const SizedBox(width: 12.0),
            Text(
              'Salir',
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: 'Manrope',
                    color: FlutterFlowTheme.of(context).error,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
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
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Manrope',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 12.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            'v.1.0.0.0',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Manrope',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 12.0,
                  letterSpacing: 0.0,
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
              color: FlutterFlowTheme.of(context).accent2,
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
          color: FlutterFlowTheme.of(context).secondaryBackground,
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
                  color: FlutterFlowTheme.of(context).primary,
                  size: 24.0,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vendedor:',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Manrope',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      ffAppState.infoSeller.nameVenden,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Manrope',
                            letterSpacing: 0.0,
                          ),
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
