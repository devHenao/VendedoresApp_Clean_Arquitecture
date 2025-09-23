import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<void> downloadOrder(
  BuildContext context,
  String? token,
  String? identificacion, {
  DateTime? startDate,
  DateTime? endDate,
}) async {
  final baseUrl = 'https://us-central1-prod-appseller-ofima.cloudfunctions.net/appSeller/clients/getOrderClient/$identificacion';
  
  // Add query parameters if dates are provided
  final params = <String, dynamic>{};
  if (startDate != null) {
    params['startDate'] = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
  }
  if (endDate != null) {
    params['endDate'] = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';
  }
  
  final uri = Uri.parse(baseUrl).replace(queryParameters: params.isNotEmpty ? params : null);

try {
    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      Uint8List fileBytes = response.bodyBytes;
      final fileName = 'reportePedidosPendientes_${identificacion}.pdf';

      print("Tamaño del archivo: ${fileBytes.length} bytes");

      if (io.Platform.isAndroid) {
        final methodChannel = MethodChannel('com.mycompany.appvendedores/media_store');
        try {
          print("Enviando datos al método nativo...");
          final savedFilePath = await methodChannel.invokeMethod<String>('saveFile', {
            'fileBytes': fileBytes,
            'fileName': fileName,
            'mimeType': 'application/pdf',
          });

          if (savedFilePath != null) {
            print("Archivo guardado en: $savedFilePath");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Archivo guardado en descargas'),
                backgroundColor: Color(0xFF39D2C0),
              ),
            );

            // Abrir el archivo inmediatamente después de guardarlo
            final result = await OpenFile.open(savedFilePath);
            print('Resultado de abrir el archivo: $result');
          } else {
            print("Error: No se pudo guardar el archivo");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al guardar el archivo.')),
            );
          }
        } catch (e) {
          print("Error en el canal: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error en el canal: $e')),
          );
        }
      } else if (io.Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$fileName';
        final file = io.File(filePath);
        await file.writeAsBytes(fileBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Archivo guardado en: $filePath'),
            backgroundColor: Color(0xFF39D2C0),
          ),
        );

        // Abrir el archivo inmediatamente después de guardarlo
        final result = await OpenFile.open(filePath);
        print('Resultado de abrir el archivo: $result');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Descarga no disponible para esta plataforma.')),
        );
      }
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No hay pedidos pendientes para esta identificación.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error ${response.statusCode}: No se pudo descargar el archivo.')),
      );
    }
  } catch (e) {
    print("Error de red o en la solicitud: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ocurrió un error al descargar el archivo.')),
    );
  }
}