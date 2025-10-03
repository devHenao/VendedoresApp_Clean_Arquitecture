import 'package:app_vendedores/shared/mensajes/ok_password/ok_password_widget.dart';
import 'package:flutter/material.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';

enum UiState { initial, loading, success, error }

class RecoveryPasswordController extends ChangeNotifier {
  RecoveryPasswordController(this.context);

  final BuildContext context;
  UiState _state = UiState.initial;
  String? _errorMessage;

  UiState get state => _state;
  String? get errorMessage => _errorMessage;

  Future<void> resetPassword(
      {required String nit, required String email}) async {
    _state = UiState.loading;
    notifyListeners();

    final apiResult = await AuthGroup.recoveryPasswordCall.call(
      nit: nit,
      email: email,
    );

    if (apiResult.succeeded) {
      _state = UiState.success;
      await _showSuccessDialog();
    } else {
      _state = UiState.error;
      _errorMessage =
          getJsonField(apiResult.jsonBody, r'''$.data''').toString();
      await _showErrorDialog();
    }
    _state = UiState.initial;
    notifyListeners();
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          alignment: const AlignmentDirectional(0.0, 0.0)
              .resolve(Directionality.of(context)),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.95,
            child: const OkPasswordWidget(),
          ),
        );
      },
    );
  }

  Future<void> _showErrorDialog() async {
    await showDialog(
      context: context,
      builder: (alertDialogContext) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(_errorMessage ?? 'Ocurrió un error desconocido.'),
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
}
