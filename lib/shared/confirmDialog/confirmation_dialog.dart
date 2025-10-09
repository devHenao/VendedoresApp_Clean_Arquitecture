import 'package:app_vendedores/core/theme/theme.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final bool showLoading;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = 'Aceptar',
    this.cancelText = 'Cancelar',
    this.showLoading = false,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Aceptar',
    String cancelText = 'Cancelar',
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: title,
          content: content,
          confirmText: confirmText,
          cancelText: cancelText,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    
    return StatefulBuilder(
      builder: (context, setState) {
        final colors = GlobalTheme.of(context);
        return AlertDialog(
          backgroundColor: colors.secondaryBackground,
          title: Text(title, style: colors.headlineSmall),
          content: SingleChildScrollView(
            child: Text(content, style: colors.bodyMedium),
          ),
          actions: [
            TextButton(
              onPressed: isLoading
                  ? null
                  : () => Navigator.of(context).pop(false),
              child: Text(
                cancelText,
                style: colors.bodyMedium.copyWith(color: colors.secondaryText),
              ),
            ),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() => isLoading = true);
                      // Simulate async operation
                      await Future.delayed(Duration.zero);
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    },
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                      ),
                    )
                  : Text(
                      confirmText,
                      style: colors.bodyMedium.copyWith(color: colors.primary),
                    ),
            ),
          ],
        );
      },
    );
  }
}
