import 'package:app_vendedores/backend/api_requests/_/api_manager.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'recovery_password_widget.dart' show RecoveryPasswordWidget;
import 'package:flutter/material.dart';

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
