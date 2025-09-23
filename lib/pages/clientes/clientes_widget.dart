import '/auth/custom_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/componentes/menu/menu_widget.dart';
import '/componentes/update_client/update_client_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'clientes_model.dart';
export 'clientes_model.dart';

class ClientesWidget extends StatefulWidget {
  const ClientesWidget({super.key});

  static String routeName = 'Clientes';
  static String routePath = '/clientes';

  @override
  State<ClientesWidget> createState() => _ClientesWidgetState();
}

class _ClientesWidgetState extends State<ClientesWidget>
    with TickerProviderStateMixin {
  late ClientesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ClientesModel());
    
    // Set initial date range to first and last day of current month
    final now = DateTime.now();
    _model.fechaInicio = DateTime(now.year, now.month, 1);
    _model.fechaFin = DateTime(now.year, now.month + 1, 0);

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      Function() _navigate = () {};
      _model.apiResultClientes = await ClientsGroup.listClientByVendenCall.call(
        token: FFAppState().infoSeller.token,
      );

      if ((_model.apiResultClientes?.succeeded ?? true)) {
        _model.clientes = (getJsonField(
          (_model.apiResultClientes?.jsonBody ?? ''),
          r'''$.data''',
          true,
        )!
                .toList()
                .map<DataClienteStruct?>(DataClienteStruct.maybeFromMap)
                .toList() as Iterable<DataClienteStruct?>)
            .withoutNulls
            .toList()
            .cast<DataClienteStruct>();
        safeSetState(() {});
      } else {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(getJsonField(
                (_model.apiResultClientes?.jsonBody ?? ''),
                r'''$.data''',
              ).toString().toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext),
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );
        GoRouter.of(context).prepareAuthEvent();
        await authManager.signOut();
        GoRouter.of(context).clearRedirectLocation();

        _navigate =
            () => context.goNamedAuth('Login', context.mounted);
      }

      _navigate();
    });

    _model.txtSearchTextController ??= TextEditingController();
    _model.txtSearchFocusNode ??= FocusNode();

    animationsMap.addAll({
      'textOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          TintEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Color(0xFC39D2C0),
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        drawer: Drawer(
          elevation: 16.0,
          child: wrapWithModel(
            model: _model.menuModel,
            updateCallback: () => safeSetState(() {}),
            child: MenuWidget(),
          ),
        ),
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 50.0,
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 30.0,
                ),
                onPressed: () async {
                  scaffoldKey.currentState!.openDrawer();
                },
              ),
            ],
          ),
          title: Visibility(
            visible: FFAppState().dataCliente.nombre != null &&
                FFAppState().dataCliente.nombre != '',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Cliente:',
                      style:
                          FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: 'Outfit',
                                color: FlutterFlowTheme.of(context).info,
                                fontSize: 22.0,
                                letterSpacing: 0.0,
                              ),
                    ),
                  ].divide(SizedBox(width: 5.0)),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      FFAppState().dataCliente != null
                          ? FFAppState().dataCliente.nombre
                          : '',
                      style:
                          FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: 'Outfit',
                                color: FlutterFlowTheme.of(context).info,
                                fontSize: 22.0,
                                letterSpacing: 0.0,
                              ),
                    ),
                  ].divide(SizedBox(width: 5.0)),
                ),
              ],
            ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            primary: false,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(12.0, 16.0, 12.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Clientes',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .override(
                                          fontFamily: 'Outfit',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 30.0,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ].divide(SizedBox(width: 5.0)),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 5.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: 200.0,
                                        child: TextFormField(
                                          controller:
                                              _model.txtSearchTextController,
                                          focusNode: _model.txtSearchFocusNode,
                                          onChanged: (_) {
                                            final searchText = _model.txtSearchTextController.text;
                                            _model.search = searchText;
                                            _model.isLoadingSearch = searchText.isNotEmpty;
                                            safeSetState(() {});
                                            
                                            EasyDebounce.debounce(
                                              '_model.txtSearchTextController',
                                              Duration(milliseconds: 1000),
                                              () async {
                                                if (mounted) {
                                                  _model.isLoadingSearch = false;
                                                  safeSetState(() {});
                                                }
                                              },
                                            );
                                          },
                                          onTap: () {
                                            // Forzar la actualización del estado cuando se hace tap en el campo
                                            safeSetState(() {});
                                          },
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            labelStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'Manrope',
                                                      letterSpacing: 0.0,
                                                    ),
                                            hintText:
                                                'Buscar por nombre o documento',
                                            hintStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'Manrope',
                                                      letterSpacing: 0.0,
                                                    ),
                                            suffixIcon: _model.txtSearchTextController.text.isNotEmpty &&
                                                    _model.txtSearchFocusNode?.hasFocus == true
                                                ? IconButton(
                                                    icon: Icon(
                                                      Icons.clear,
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                      size: 20.0,
                                                    ),
                                                    onPressed: () {
                                                      _model.txtSearchTextController?.clear();
                                                      _model.search = '';
                                                      _model.isLoadingSearch = false;
                                                      // Mover el foco al campo después de limpiar
                                                      _model.txtSearchFocusNode?.requestFocus();
                                                      safeSetState(() {});
                                                    },
                                                  )
                                                : null,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            filled: true,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Manrope',
                                                letterSpacing: 0.0,
                                              ),
                                          cursorColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          validator: _model
                                              .txtSearchTextControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 20.0)),
                                ),
                              ),
                              // Filtros de fecha
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 4.0),
                                child: Text(
                                  'Selecciona el rango de fechas para filtrar los reportes',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Manrope',
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          final date = await showDatePicker(
                                            context: context,
                                            initialDate: _model.fechaInicio ?? DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: _model.fechaFin ?? DateTime(2100),
                                            helpText: 'Seleccione fecha inicial',
                                            builder: (context, child) {
                                              return Theme(
                                                data: Theme.of(context).copyWith(
                                                  colorScheme: ColorScheme.light(
                                                    primary: FlutterFlowTheme.of(context).primary,
                                                    onPrimary: Colors.white,
                                                    surface: Colors.white,
                                                    onSurface: Colors.black,
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );
                                          if (date != null) {
                                            if (_model.fechaFin != null && date.isAfter(_model.fechaFin!)) {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text('Fecha inválida'),
                                                    content: Text('La fecha inicial no puede ser posterior a la fecha final.'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(alertDialogContext),
                                                        child: Text('Aceptar'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              setState(() {
                                                _model.fechaInicio = date;
                                              });
                                            }
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: FlutterFlowTheme.of(context).alternate,
                                            ),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _model.fechaInicio != null
                                                    ? DateFormat('dd/MM/yyyy').format(_model.fechaInicio!)
                                                    : 'Fecha de inicio',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                              Icon(
                                                Icons.calendar_today,
                                                size: 20,
                                                color: FlutterFlowTheme.of(context).primary,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          final date = await showDatePicker(
                                            context: context,
                                            initialDate: _model.fechaFin ?? (_model.fechaInicio ?? DateTime.now()),
                                            firstDate: _model.fechaInicio ?? DateTime(2000),
                                            lastDate: DateTime(2100),
                                            helpText: 'Seleccione fecha final',
                                            builder: (context, child) {
                                              return Theme(
                                                data: Theme.of(context).copyWith(
                                                  colorScheme: ColorScheme.light(
                                                    primary: FlutterFlowTheme.of(context).primary,
                                                    onPrimary: Colors.white,
                                                    surface: Colors.white,
                                                    onSurface: Colors.black,
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );
                                          if (date != null) {
                                            if (_model.fechaInicio != null && date.isBefore(_model.fechaInicio!)) {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
                                                  return AlertDialog(
                                                    title: Text('Fecha inválida'),
                                                    content: Text('La fecha final no puede ser anterior a la fecha inicial.'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(alertDialogContext),
                                                        child: Text('Aceptar'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              setState(() {
                                                _model.fechaFin = date;
                                              });
                                            }
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: FlutterFlowTheme.of(context).alternate,
                                            ),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _model.fechaFin != null
                                                    ? DateFormat('dd/MM/yyyy').format(_model.fechaFin!)
                                                    : 'Fecha de fin',
                                                style: FlutterFlowTheme.of(context).bodyMedium,
                                              ),
                                              Icon(
                                                Icons.calendar_today,
                                                size: 20,
                                                color: FlutterFlowTheme.of(context).primary,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (_model.fechaInicio != null || _model.fechaFin != null)
                                      IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: FlutterFlowTheme.of(context).error,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _model.fechaInicio = null;
                                            _model.fechaFin = null;
                                          });
                                        },
                                      ),
                                  ].divide(SizedBox(width: 8.0)),
                                ),
                              ),
                              Divider(
                                thickness: 2.0,
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (((_model.clientes.isNotEmpty) != true && _model.hasClientes == true) ||
                          _model.isLoadingSearch)
                        Column(
                          children: [
                            SizedBox(height: 20),
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              _model.isLoadingSearch 
                                  ? 'Buscando clientes...' 
                                  : 'Cargando...',
                              style: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Manrope',
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      if (!_model.hasClientes)
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_off_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 30.0,
                            ),
                            Text(
                              'No se encontro cliente',
                              style: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Manrope',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 20.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            12.0, 0.0, 12.0, 10.0),
                        child: Container(
                          width: double.infinity,
                          height: 625.0,
                          decoration: BoxDecoration(),
                          child: Builder(
                            builder: (context) {
                              //MAPEO CONSULTA
                              final listaClientes = _model.clientes
                                  .map((e) => e)
                                  .toList()
                                  .where((e) => () {
                                        if (_model.search == null ||
                                            _model.search == '') {
                                          return true;
                                        } else if (functions.showSearchResult(
                                                _model.search, e.nombre) ==
                                            false) {
                                          return functions.showSearchResult(
                                              _model.search, e.nit)!;
                                        } else {
                                          return functions.showSearchResult(
                                              _model
                                                  .txtSearchTextController.text,
                                              e.nombre)!;
                                        }
                                      }())
                                  .toList()
                                  .sortedList(
                                      keyOf: (e) => e.nombre, desc: false)
                                  .toList();

                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: listaClientes.length,
                                itemBuilder: (context, listaClientesIndex) {
                                  final listaClientesItem =
                                      listaClientes[listaClientesIndex];
                                  return Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      if (FFAppState().itemId !=
                                          listaClientesIndex)
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            if (FFAppState()
                                                .shoppingCart
                                                .isNotEmpty) {
                                              var confirmDialogResponse =
                                                  await showDialog<bool>(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                '¡Espera, aún no terminas tu pedido!'),
                                                            content: Text(
                                                                '¿Seguro que desas cambiar de cliente?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext,
                                                                        false),
                                                                child: Text(
                                                                    'Cancelar'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext,
                                                                        true),
                                                                child: Text(
                                                                    'Confirmar'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ) ??
                                                      false;
                                              if (confirmDialogResponse) {
                                                FFAppState().itemId =
                                                    listaClientesIndex;
                                                FFAppState().dataCliente =
                                                    listaClientesItem;
                                                safeSetState(() {});
                                                FFAppState().shoppingCart = [];
                                                FFAppState().productList = [];
                                                FFAppState().store = [];
                                                safeSetState(() {});
                                              }
                                            } else {
                                              FFAppState().itemId =
                                                  listaClientesIndex;
                                              FFAppState().dataCliente =
                                                  listaClientesItem;
                                              FFAppState().productList = [];
                                              safeSetState(() {});
                                            }
                                          },
                                          child: Card(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            elevation: 2.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      10.0, 10.0, 10.0, 10.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                listaClientesItem
                                                                    .nit,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Manrope',
                                                                      fontSize:
                                                                          20.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              listaClientesItem
                                                                  .nombre,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Manrope',
                                                                    letterSpacing:
                                                                        0.0,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              valueOrDefault<
                                                                  String>(
                                                                listaClientesItem
                                                                    .contacto,
                                                                'Contacto',
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Manrope',
                                                                    letterSpacing:
                                                                        0.0,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              listaClientesItem
                                                                  .tel1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Manrope',
                                                                    letterSpacing:
                                                                        0.0,
                                                                  ),
                                                            ),
                                                          ].divide(SizedBox(
                                                              width: 5.0)),
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              valueOrDefault<
                                                                  String>(
                                                                listaClientesItem
                                                                    .email,
                                                                'Sin Correo',
                                                              ).maybeHandleOverflow(
                                                                maxChars: 20,
                                                                replacement:
                                                                    '…',
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Manrope',
                                                                    letterSpacing:
                                                                        0.0,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              listaClientesItem
                                                                  .direccion
                                                                  .maybeHandleOverflow(
                                                                maxChars: 20,
                                                                replacement:
                                                                    '…',
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Manrope',
                                                                    letterSpacing:
                                                                        0.0,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        Divider(
                                                          thickness: 2.0,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .alternate,
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                Builder(
                                                                  builder: (context) =>
                                                                      FlutterFlowIconButton(
                                                                    borderRadius: 8.0,
                                                                    buttonSize: 46.0,
                                                                    fillColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .info,
                                                                    icon: Icon(
                                                                      Icons
                                                                          .remove_red_eye_rounded,
                                                                      color:
                                                                          FlutterFlowTheme.of(context)
                                                                              .primary,
                                                                      size: 30.0,
                                                                    ),
                                                                    showLoadingIndicator: true,
                                                                    onPressed: () async {
                                                                      await showDialog(
                                                                        context: context,
                                                                        builder: (dialogContext) {
                                                                          return Dialog(
                                                                            elevation: 0,
                                                                            insetPadding:
                                                                                EdgeInsets.zero,
                                                                            backgroundColor: Colors
                                                                                .transparent,
                                                                            alignment: AlignmentDirectional(
                                                                                    0.0,
                                                                                    0.0)
                                                                                .resolve(Directionality.of(
                                                                                    context)),
                                                                            child: GestureDetector(
                                                                              onTap: () {
                                                                                FocusScope.of(dialogContext)
                                                                                    .unfocus();
                                                                                FocusManager
                                                                                    .instance
                                                                                    .primaryFocus
                                                                                    ?.unfocus();
                                                                              },
                                                                              child:
                                                                                  UpdateClientWidget(
                                                                                dataClients:
                                                                                    listaClientesItem,
                                                                                updated: () async {
                                                                                  _model.apiResultListaClientesUpdate =
                                                                                      await ClientsGroup.listClientByVendenCall.call(
                                                                                    token: FFAppState().infoSeller.token,
                                                                                  );

                                                                                  if ((_model.apiResultListaClientesUpdate?.succeeded ??
                                                                                      true)) {
                                                                                    _model.clientes = (getJsonField(
                                                                                      (_model.apiResultListaClientesUpdate?.jsonBody ??
                                                                                          ''),
                                                                                      r'''$.data''',
                                                                                      true,
                                                                                    )!
                                                                                            .toList()
                                                                                            .map<DataClienteStruct?>(DataClienteStruct.maybeFromMap)
                                                                                            .toList() as Iterable<DataClienteStruct?>)
                                                                                        .withoutNulls
                                                                                        .toList()
                                                                                        .cast<
                                                                                            DataClienteStruct>();
                                                                                    safeSetState(() {});
                                                                                  } else {
                                                                                    await showDialog(
                                                                                      context:
                                                                                          context,
                                                                                      builder: (alertDialogContext) {
                                                                                        return AlertDialog(
                                                                                          title: Text(
                                                                                              'Error'),
                                                                                          content:
                                                                                              Text(getJsonField(
                                                                                            (_model.apiResultListaClientesUpdate?.jsonBody ??
                                                                                                ''),
                                                                                            r'''$.data''',
                                                                                          ).toString()),
                                                                                          actions: [
                                                                                            TextButton(
                                                                                              onPressed: () =>
                                                                                                  Navigator.pop(alertDialogContext),
                                                                                              child: Text(
                                                                                                  'Ok'),
                                                                                            ),
                                                                                          ],
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  }
                                                                                },
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );

                                                                      safeSetState(() {});
                                                                    },
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'Detalle',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily: 'Manrope',
                                                                        letterSpacing: 0.0,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                FlutterFlowIconButton(
                                                                  borderColor:
                                                                      Colors.transparent,
                                                                  borderRadius: 8.0,
                                                                  buttonSize: 46.0,
                                                                  fillColor:
                                                                      FlutterFlowTheme.of(context)
                                                                          .info,
                                                                  icon: Icon(
                                                                    Icons.wallet,
                                                                    color:
                                                                        FlutterFlowTheme.of(context)
                                                                            .success,
                                                                    size: 30.0,
                                                                  ),
                                                                  showLoadingIndicator: true,
                                                                  onPressed: () async {
                                                                    await actions
                                                                        .dowloandWallet(
                                                                      context,
                                                                      FFAppState()
                                                                          .infoSeller
                                                                          .token,
                                                                      listaClientesItem.nit,
                                                                      startDate: _model.fechaInicio,
                                                                      endDate: _model.fechaFin,
                                                                    );
                                                                  },
                                                                ),
                                                                Text(
                                                                  'Cartera',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily: 'Manrope',
                                                                        letterSpacing: 0.0,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                FlutterFlowIconButton(
                                                                  borderColor:
                                                                      Colors.transparent,
                                                                  borderRadius: 8.0,
                                                                  buttonSize: 46.0,
                                                                  fillColor:
                                                                      FlutterFlowTheme.of(context)
                                                                          .info,
                                                                  icon: Icon(
                                                                    Icons
                                                                        .pending_actions_rounded,
                                                                    color:
                                                                        Color(0xFFF87C23),
                                                                    size: 30.0,
                                                                  ),
                                                                  showLoadingIndicator: true,
                                                                  onPressed: () async {
                                                                    await actions
                                                                        .downloadOrder(
                                                                      context,
                                                                      FFAppState()
                                                                          .infoSeller
                                                                          .token,
                                                                      listaClientesItem.nit,
                                                                      startDate: _model.fechaInicio,
                                                                      endDate: _model.fechaFin,
                                                                    );
                                                                  },
                                                                ),
                                                                Text(
                                                                  'Pendientes',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily: 'Manrope',
                                                                        letterSpacing: 0.0,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                FlutterFlowIconButton(
                                                                  borderColor:
                                                                      Colors.transparent,
                                                                  borderRadius: 8.0,
                                                                  buttonSize: 46.0,
                                                                  fillColor:
                                                                      FlutterFlowTheme.of(context)
                                                                          .info,
                                                                  icon: Icon(
                                                                    Icons
                                                                        .content_paste_search_rounded,
                                                                    color:
                                                                        FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                    size: 30.0,
                                                                  ),
                                                                  showLoadingIndicator: true,
                                                                  onPressed: () async {
                                                                    await actions
                                                                        .downloadLastSales(
                                                                      context,
                                                                      FFAppState()
                                                                          .infoSeller
                                                                          .token,
                                                                      listaClientesItem.nit,
                                                                      startDate: _model.fechaInicio,
                                                                      endDate: _model.fechaFin,
                                                                    );
                                                                  },
                                                                ),
                                                                Text(
                                                                  'Ventas',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily: 'Manrope',
                                                                        letterSpacing: 0.0,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ].divide(SizedBox(
                                                          height: 5.0)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (FFAppState().itemId ==
                                          listaClientesIndex)
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            FFAppState().itemId = -1;
                                            FFAppState().dataCliente =
                                                DataClienteStruct
                                                    .fromSerializableMap(
                                                        jsonDecode('{}'));
                                            safeSetState(() {});
                                          },
                                          child: Card(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            elevation: 2.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(10.0, 10.0,
                                                          10.0, 10.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        listaClientesItem
                                                                            .nit,
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Manrope',
                                                                              fontSize: 20.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  hoverColor: Colors
                                                                      .transparent,
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  onTap:
                                                                      () async {
                                                                    context.pushNamed(
                                                                        ProductosWidget
                                                                            .routeName);
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .shopping_bag,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                    size: 40.0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Text(
                                                                  listaClientesItem
                                                                      .nombre,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Manrope',
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    listaClientesItem
                                                                        .contacto,
                                                                    'Contacto',
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Manrope',
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  listaClientesItem
                                                                      .tel1,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Manrope',
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                                ),
                                                              ].divide(SizedBox(
                                                                  width: 5.0)),
                                                            ),
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    listaClientesItem
                                                                        .email,
                                                                    'Sin Correo',
                                                                  ).maybeHandleOverflow(
                                                                    maxChars:
                                                                        20,
                                                                    replacement:
                                                                        '…',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Manrope',
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Text(
                                                                  listaClientesItem
                                                                      .direccion
                                                                      .maybeHandleOverflow(
                                                                    maxChars:
                                                                        20,
                                                                    replacement:
                                                                        '…',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Manrope',
                                                                        letterSpacing:
                                                                            0.0,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                            Divider(
                                                              thickness: 2.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .accent4,
                                                            ),
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Builder(
                                                                  builder:
                                                                      (context) =>
                                                                          FlutterFlowIconButton(
                                                                    borderColor:
                                                                        Colors
                                                                            .transparent,
                                                                    borderRadius:
                                                                        8.0,
                                                                    buttonSize:
                                                                        46.0,
                                                                    fillColor: FlutterFlowTheme.of(
                                                                            context)
                                                                        .alternate,
                                                                    icon: Icon(
                                                                      Icons
                                                                          .remove_red_eye_rounded,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      size:
                                                                          30.0,
                                                                    ),
                                                                    showLoadingIndicator:
                                                                        true,
                                                                    onPressed:
                                                                        () async {
                                                                      await showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (dialogContext) {
                                                                          return Dialog(
                                                                            elevation:
                                                                                0,
                                                                            insetPadding:
                                                                                EdgeInsets.zero,
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                            alignment:
                                                                                AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                FocusScope.of(dialogContext).unfocus();
                                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                                              },
                                                                              child: UpdateClientWidget(
                                                                                dataClients: listaClientesItem,
                                                                                updated: () async {
                                                                                  _model.apiResultListaClientesUpdateSelecte = await ClientsGroup.listClientByVendenCall.call(
                                                                                    token: FFAppState().infoSeller.token,
                                                                                  );

                                                                                  if ((_model.apiResultListaClientesUpdateSelecte?.succeeded ?? true)) {
                                                                                    _model.clientes = (getJsonField(
                                                                                      (_model.apiResultListaClientesUpdateSelecte?.jsonBody ?? ''),
                                                                                      r'''$.data''',
                                                                                      true,
                                                                                    )!
                                                                                            .toList()
                                                                                            .map<DataClienteStruct?>(DataClienteStruct.maybeFromMap)
                                                                                            .toList() as Iterable<DataClienteStruct?>)
                                                                                        .withoutNulls
                                                                                        .toList()
                                                                                        .cast<DataClienteStruct>();
                                                                                    safeSetState(() {});
                                                                                  } else {
                                                                                    await showDialog(
                                                                                      context: context,
                                                                                      builder: (alertDialogContext) {
                                                                                        return AlertDialog(
                                                                                          title: Text('Error'),
                                                                                          content: Text(getJsonField(
                                                                                            (_model.apiResultListaClientesUpdateSelecte?.jsonBody ?? ''),
                                                                                            r'''$.data''',
                                                                                          ).toString()),
                                                                                          actions: [
                                                                                            TextButton(
                                                                                              onPressed: () => Navigator.pop(alertDialogContext),
                                                                                              child: Text('Ok'),
                                                                                            ),
                                                                                          ],
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  }
                                                                                },
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );

                                                                      safeSetState(
                                                                          () {});
                                                                    },
                                                                  ),
                                                                ),
                                                                FlutterFlowIconButton(
                                                                  borderColor:
                                                                      Colors
                                                                          .transparent,
                                                                  borderRadius:
                                                                      8.0,
                                                                  buttonSize:
                                                                      46.0,
                                                                  fillColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                                  icon: Icon(
                                                                    Icons
                                                                        .wallet,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .success,
                                                                    size: 30.0,
                                                                  ),
                                                                  showLoadingIndicator:
                                                                      true,
                                                                  onPressed:
                                                                      () async {
                                                                    await actions
                                                                        .dowloandWallet(
                                                                      context,
                                                                      FFAppState()
                                                                          .infoSeller
                                                                          .token,
                                                                      listaClientesItem
                                                                          .nit,
                                                                      startDate: _model.fechaInicio,
                                                                      endDate: _model.fechaFin,
                                                                    );
                                                                  },
                                                                ),
                                                                FlutterFlowIconButton(
                                                                  borderColor:
                                                                      Colors
                                                                          .transparent,
                                                                  borderRadius:
                                                                      8.0,
                                                                  buttonSize:
                                                                      46.0,
                                                                  fillColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                                  icon: Icon(
                                                                    Icons
                                                                        .pending_actions_rounded,
                                                                    color: Color(
                                                                        0xFFF87C23),
                                                                    size: 30.0,
                                                                  ),
                                                                  showLoadingIndicator:
                                                                      true,
                                                                  onPressed:
                                                                      () async {
                                                                    await actions
                                                                        .downloadOrder(
                                                                      context,
                                                                      FFAppState()
                                                                          .infoSeller
                                                                          .token,
                                                                      listaClientesItem
                                                                          .nit,
                                                                      startDate: _model.fechaInicio,
                                                                      endDate: _model.fechaFin,
                                                                    );
                                                                  },
                                                                ),
                                                                FlutterFlowIconButton(
                                                                  borderColor:
                                                                      Colors
                                                                          .transparent,
                                                                  borderRadius:
                                                                      8.0,
                                                                  buttonSize:
                                                                      46.0,
                                                                  fillColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                                  icon: Icon(
                                                                    Icons
                                                                        .content_paste_search_rounded,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    size: 30.0,
                                                                  ),
                                                                  showLoadingIndicator:
                                                                      true,
                                                                  onPressed:
                                                                      () async {
                                                                    await actions
                                                                        .downloadLastSales(
                                                                      context,
                                                                      FFAppState()
                                                                          .infoSeller
                                                                          .token,
                                                                      listaClientesItem
                                                                          .nit,
                                                                      startDate: _model.fechaInicio,
                                                                      endDate: _model.fechaFin,
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ].divide(SizedBox(
                                                              height: 5.0)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ]
                                        .divide(SizedBox(height: 5.0))
                                        .around(SizedBox(height: 5.0)),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
