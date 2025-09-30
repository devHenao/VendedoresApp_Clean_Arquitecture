import 'package:flutter/material.dart';
import 'confirmation_dialog_model.dart';

export 'confirmation_dialog_model.dart';

class ConfirmationDialogWidget extends StatefulWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;
  final Color? confirmTextColor;
  final Color? cancelTextColor;

  const ConfirmationDialogWidget({
    Key? key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.onCancel,
    this.confirmText = 'Aceptar',
    this.cancelText = 'Cancelar',
    this.confirmButtonColor,
    this.cancelButtonColor,
    this.confirmTextColor = Colors.white,
    this.cancelTextColor = Colors.black87,
  }) : super(key: key);

  @override
  State<ConfirmationDialogWidget> createState() => _ConfirmationDialogWidgetState();
}

class _ConfirmationDialogWidgetState extends State<ConfirmationDialogWidget> {
  late ConfirmationDialogModel _model;

  @override
  void initState() {
    super.initState();
    _model = ConfirmationDialogModel();
    _model.initState(context);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(widget.message),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: widget.cancelTextColor,
            backgroundColor: widget.cancelButtonColor,
          ),
          onPressed: () {
            if (widget.onCancel != null) {
              widget.onCancel!();
            } else {
              Navigator.of(context).pop(false);
            }
          },
          child: Text(widget.cancelText),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.confirmButtonColor ?? Theme.of(context).primaryColor,
            foregroundColor: widget.confirmTextColor,
          ),
          onPressed: () {
            widget.onConfirm();
            Navigator.of(context).pop(true);
          },
          child: Text(widget.confirmText),
        ),
      ],
    );
  }
}
