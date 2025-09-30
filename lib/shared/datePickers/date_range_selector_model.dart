import 'package:flutter/material.dart';

/// Model class for date range selector configuration.
class DateRangeSelectorModel {
  /// The title displayed above the date picker.
  final String? title;
  
  /// Label for the start date field.
  final String startDateLabel;
  
  /// Label for the end date field.
  final String endDateLabel;
  
  /// Hint text for the start date field.
  final String startDateHint;
  
  /// Hint text for the end date field.
  final String endDateHint;
  
  /// The primary color of the date picker.
  final Color? primaryColor;
  
  /// The text color of the date picker.
  final Color? textColor;
  
  /// The border color of the date picker fields.
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

  /// Creates a copy of this model with the given fields replaced by the non-null values.
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
