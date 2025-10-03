import 'dart:convert';
import 'package:http/http.dart' as http;

class RecoveryPasswordDatasource {
  final String _baseUrl = 'https://us-central1-prod-appseller-ofima.cloudfunctions.net/appAuthSeller';

  Future<void> resetPassword({required String nit, required String email}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/sendEmailRecoveryPassword'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'identification': nit,
          'email': email,
        }),
      );

      if (response.statusCode != 200) {
        final responseData = jsonDecode(response.body);
        throw responseData['data']?.toString() ?? 'Error al intentar recuperar la contraseña';
      }
    } catch (e) {
      throw 'Error de conexión: $e';
    }
  }
}
