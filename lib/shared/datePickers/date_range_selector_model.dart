import 'package:flutter/material.dart';

class DateRangeSelectorModel {
  final String? title;
  
  final String startDateLabel;
  
  final String endDateLabel;
  
  final String startDateHint;
  
  final String endDateHint;
  
  final Color? primaryColor;
  
  final Color? textColor;
  
  final Color? borderColor;

  const DateRangeSelectorModel({
    this.title = 'Selecciona el rango de fechas',
    this.startDateLabel = 'Fecha de inicio',
    this.endDateLabel = 'Fecha de fin',
    this.startDateHint = 'Seleccione fecha inicial',
    this.endDateHint = 'Seleccione fecha final',
    this.primaryColor,
    this.textColor,
    this.borderColor,
  });

  DateRangeSelectorModel copyWith({
    String? title,
    String? startDateLabel,
    String? endDateLabel,
    String? startDateHint,
    String? endDateHint,
    Color? primaryColor,
    Color? textColor,
    Color? borderColor,
  }) {
    return DateRangeSelectorModel(
      title: title ?? this.title,
      startDateLabel: startDateLabel ?? this.startDateLabel,
      endDateLabel: endDateLabel ?? this.endDateLabel,
      startDateHint: startDateHint ?? this.startDateHint,
      endDateHint: endDateHint ?? this.endDateHint,
      primaryColor: primaryColor ?? this.primaryColor,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
    );
  }
}
