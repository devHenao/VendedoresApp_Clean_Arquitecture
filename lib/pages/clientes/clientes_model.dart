import 'package:app_vendedores/backend/api_requests/_/api_manager.dart';

import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/componentes/menu/menu_widget.dart';
import '/componentes/update_client/update_client_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'clientes_widget.dart' show ClientesWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ClientesModel extends FlutterFlowModel<ClientesWidget> {
  ///  Local state fields for this page.

  List<DataClienteStruct> clientes = [];
  void addToClientes(DataClienteStruct item) => clientes.add(item);
  void removeFromClientes(DataClienteStruct item) => clientes.remove(item);
  void removeAtIndexFromClientes(int index) => clientes.removeAt(index);
  void insertAtIndexInClientes(int index, DataClienteStruct item) =>
      clientes.insert(index, item);
  void updateClientesAtIndex(int index, Function(DataClienteStruct) updateFn) =>
      clientes[index] = updateFn(clientes[index]);

  String? search;

  bool hasClientes = true;
  bool isLoadingSearch = false;
  
  // Filtros de fecha
  DateTime? fechaInicio;
  DateTime? fechaFin;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (ListClientByVenden)] action in Clientes widget.
  ApiCallResponse? apiResultClientes;
  // Model for Menu component.
  late MenuModel menuModel;
  // State field(s) for txtSearch widget.
  FocusNode? txtSearchFocusNode;
  TextEditingController? txtSearchTextController;
  String? Function(BuildContext, String?)? txtSearchTextControllerValidator;
  // Stores action output result for [Backend Call - API (ListClientByVenden)] action in btnDeatilClient widget.
  ApiCallResponse? apiResultListaClientesUpdate;
  // Stores action output result for [Backend Call - API (ListClientByVenden)] action in btnDeatilClient widget.
  ApiCallResponse? apiResultListaClientesUpdateSelecte;

  @override
  void initState(BuildContext context) {
    menuModel = createModel(context, () => MenuModel());
  }

  @override
  void dispose() {
    menuModel.dispose();
    txtSearchFocusNode?.dispose();
    txtSearchTextController?.dispose();
  }
}
