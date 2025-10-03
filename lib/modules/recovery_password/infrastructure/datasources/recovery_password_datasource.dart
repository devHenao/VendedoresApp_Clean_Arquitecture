import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RecoveryPasswordDatasource {
  Future<void> resetPassword({required String nit, required String email}) async {
    final apiResult = await AuthGroup.recoveryPasswordCall.call(
      nit: nit,
      email: email,
    );

    if (!apiResult.succeeded) {
      throw getJsonField(apiResult.jsonBody, r'''$.data''').toString();
    }
  }
}
