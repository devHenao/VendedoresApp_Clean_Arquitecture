import 'package:app_vendedores/core/theme/theme.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final bool showLoading;
  final IconData icon;
  final Color? iconColor;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = 'Aceptar',
    this.cancelText = 'Cancelar',
    this.showLoading = false,
    this.icon = Icons.help_outline,
    this.iconColor,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Aceptar',
    String cancelText = 'Cancelar',
    bool barrierDismissible = true,
    IconData icon = Icons.help_outline,
    Color? iconColor,
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
          icon: icon,
          iconColor: iconColor ?? GlobalTheme.of(context).secondaryText,
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
        return Dialog(
          backgroundColor: colors.secondaryBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: iconColor ?? colors.secondaryText, size: 48.0),
                const SizedBox(height: 16.0),
                Text(title, textAlign: TextAlign.center, style: colors.headlineSmall),
                const SizedBox(height: 8.0),
                Text(content, textAlign: TextAlign.center, style: colors.bodyMedium),
                const SizedBox(height: 24.0),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: isLoading ? null : () => Navigator.of(context).pop(false),
                        child: Text(
                          cancelText,
                          style: colors.bodyMedium.copyWith(color: colors.secondaryText),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                setState(() => isLoading = true);
                                await Future.delayed(Duration.zero);
                                if (context.mounted) {
                                  Navigator.of(context).pop(true);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.info,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(colors.info),
                                ),
                              )
                            : Text(confirmText),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
