import '/auth/custom_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'menu_model.dart';
import 'menu_widgets.dart';
export 'menu_model.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key});

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  late MenuModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MenuModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Stack(
      children: [
        Container(
          width: 300.0,
          height: MediaQuery.sizeOf(context).height * 1.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 20.0, 16.0, 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MenuHeader(),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        child: Text(
                          'Menu',
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Outfit',
                                color: FlutterFlowTheme.of(context).primary,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const MenuItems(),
                  MenuActions(onSignOut: () {
                    // Función para navegar al login
                    void navigateToLogin() {
                      if (!mounted) return;
                      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                        '/Login',
                        (route) => false,
                      );
                    }

                    // Iniciar la operación asíncrona
                    Future(() async {
                      try {
                        // Limpiar el estado de la aplicación
                        FFAppState().resetAppState();

                        // Actualizar la UI si el widget sigue montado
                        if (mounted) {
                          setState(() {});
                        }

                        // Pequeña pausa para asegurar actualizaciones de UI
                        await Future.delayed(const Duration(milliseconds: 100));

                        // Verificar nuevamente si el widget está montado
                        if (!mounted) return;

                        // Realizar operaciones de cierre de sesión
                        await authManager.signOut();

                        // Navegar al login
                        if (mounted) {
                          navigateToLogin();
                        }
                      } catch (e) {
                        debugPrint('Error during sign out: $e');
                        // Navigate to login even if there was an error
                        if (mounted) {
                          navigateToLogin();
                        }
                      }
                    });
                  }),
                ].divide(const SizedBox(height: 16.0)),
              ),
            ),
          ),
        ),
        const MenuFooter(),
      ],
    );
  }
}
