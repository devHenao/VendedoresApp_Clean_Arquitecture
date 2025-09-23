import 'package:app_vendedores/backend/api_requests/_/api_manager.dart';

import '/backend/api_requests/api_calls.dart';
import '/componentes/mensajes/ok_password/ok_password_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'recovery_password_widget.dart' show RecoveryPasswordWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RecoveryPasswordModel extends FlutterFlowModel<RecoveryPasswordWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for txtNit widget.
  FocusNode? txtNitFocusNode;
  TextEditingController? txtNitTextController;
  String? Function(BuildContext, String?)? txtNitTextControllerValidator;
  String? _txtNitTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Debes ingresar el Nit';
    }

    return null;
  }

  // State field(s) for txtCorreo widget.
  FocusNode? txtCorreoFocusNode;
  TextEditingController? txtCorreoTextController;
  String? Function(BuildContext, String?)? txtCorreoTextControllerValidator;
  String? _txtCorreoTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Debes ingresar el correo electrónico';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Debe ser un correo válido';
    }
    return null;
  }

  // Stores action output result for [Backend Call - API (RecoveryPassword)] action in btnResetPassword widget.
  ApiCallResponse? apiResultRecoveryPassword;

  @override
  void initState(BuildContext context) {
    txtNitTextControllerValidator = _txtNitTextControllerValidator;
    txtCorreoTextControllerValidator = _txtCorreoTextControllerValidator;
  }

  @override
  void dispose() {
    txtNitFocusNode?.dispose();
    txtNitTextController?.dispose();

    txtCorreoFocusNode?.dispose();
    txtCorreoTextController?.dispose();
  }
}
