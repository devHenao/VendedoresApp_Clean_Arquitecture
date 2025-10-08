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
      await Future.microtask(() => onConfirm());
      
      if (context.mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(false);
      }
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
