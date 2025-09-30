import 'package:flutter/material.dart';

class ConfirmationDialogModel extends ChangeNotifier {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  bool _isLoading = false;
  
  ConfirmationDialogModel({
    required this.title,
    required this.content,
    this.confirmText = 'Aceptar',
    this.cancelText = 'Cancelar',
  });

  bool get isLoading => _isLoading;
  
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
