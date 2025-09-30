import 'package:flutter/material.dart';
import 'confirmation_dialog_model.dart';

class ConfirmationDialogController extends ChangeNotifier {
  final ConfirmationDialogModel model;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final BuildContext context;

  ConfirmationDialogController({
    required this.context,
    required this.model,
    required this.onConfirm,
    this.onCancel,
  });

  Future<void> confirm() async {
    if (model.isLoading) return;
    
    try {
      model.setLoading(true);
      // Ejecutar la acción de confirmación
      await Future.microtask(() => onConfirm());
      
      // Cerrar el diálogo después de que la acción se complete
      if (context.mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      // Si hay un error, cerramos el diálogo
      if (context.mounted) {
        Navigator.of(context).pop(false);
      }
      // Relanzamos la excepción para que pueda ser manejada por quien llame al diálogo
      rethrow;
    } finally {
      if (context.mounted) {
        model.setLoading(false);
      }
    }
  }

  void cancel() {
    onCancel?.call();
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(false);
    }
  }
}
