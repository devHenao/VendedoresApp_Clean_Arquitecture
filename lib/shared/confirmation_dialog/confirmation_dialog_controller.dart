import 'package:flutter/material.dart';
import 'confirmation_dialog_widget.dart';

/// Controlador para mostrar diálogos de confirmación de manera consistente en la aplicación.
/// Proporciona un método estático [showConfirmationDialog] que muestra un diálogo de confirmación
/// con opciones personalizables.
class ConfirmationDialogController {
  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Aceptar',
    String cancelText = 'Cancelar',
    Color? confirmButtonColor,
    Color? cancelButtonColor,
    Color? confirmTextColor,
    Color? cancelTextColor,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialogWidget(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmButtonColor: confirmButtonColor,
        cancelButtonColor: cancelButtonColor,
        confirmTextColor: confirmTextColor,
        cancelTextColor: cancelTextColor,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }
}
