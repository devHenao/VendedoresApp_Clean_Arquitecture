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
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(content),
          ),
          actions: [
            TextButton(
              onPressed: isLoading
                  ? null
                  : () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() => isLoading = true);
                      await Future.delayed(Duration.zero);
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}
