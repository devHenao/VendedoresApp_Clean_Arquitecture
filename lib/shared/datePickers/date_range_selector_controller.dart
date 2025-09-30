import 'package:flutter/material.dart';

/// Controller for managing the date range selection state and logic.
class DateRangeSelectorController extends ChangeNotifier {
  DateTime? _startDate;
  DateTime? _endDate;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  /// Updates the start date and notifies listeners.
  void updateStartDate(DateTime? date) {
    _startDate = date;
    notifyListeners();
  }

  /// Updates the end date and notifies listeners.
  void updateEndDate(DateTime? date) {
    _endDate = date;
    notifyListeners();
  }

  /// Clears both dates and notifies listeners.
  void clearDates() {
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }

  /// Returns true if both dates are selected.
  bool get isRangeComplete => _startDate != null && _endDate != null;

  /// Returns a string representation of the selected date range.
  String getFormattedDateRange() {
    if (_startDate == null && _endDate == null) return '';
    if (_startDate == null) return 'Hasta ${_formatDate(_endDate!)}';
    if (_endDate == null) return 'Desde ${_formatDate(_startDate!)}';
    return '${_formatDate(_startDate!)} - ${_formatDate(_endDate!)}';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year}';
  }
}
