import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'confirmation_dialog_model.dart';
import 'confirmation_dialog_controller.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool barrierDismissible;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = 'Aceptar',
    this.cancelText = 'Cancelar',
    required this.onConfirm,
    this.onCancel,
    this.barrierDismissible = true,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Aceptar',
    String cancelText = 'Cancelar',
    bool barrierDismissible = true,
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        final model = ConfirmationDialogModel(
          title: title,
          content: content,
          confirmText: confirmText,
          cancelText: cancelText,
        );
        
        return ChangeNotifierProvider.value(
          value: model,
          child: ConfirmationDialog(
            title: title,
            content: content,
            confirmText: confirmText,
            cancelText: cancelText,
            onConfirm: () => Navigator.of(context).pop(true),
            onCancel: () => Navigator.of(context).pop(false),
            barrierDismissible: barrierDismissible,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ConfirmationDialogModel>(context, listen: true);
    final controller = ConfirmationDialogController(
      context: context,
      model: model,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );

    return PopScope(
      canPop: !model.isLoading,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          controller.cancel();
        }
      },
      child: AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content),
        ),
        actions: [
          TextButton(
            onPressed: model.isLoading ? null : controller.cancel,
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: model.isLoading ? null : controller.confirm,
            child: model.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(confirmText),
          ),
        ],
      ),
    );
  }
}
