import 'package:flutter/material.dart';

class DateRangeSelectorController extends ChangeNotifier {
  DateTime? _startDate;
  DateTime? _endDate;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  void updateStartDate(DateTime? date) {
    _startDate = date;
    notifyListeners();
  }

  void updateEndDate(DateTime? date) {
    _endDate = date;
    notifyListeners();
  }

  void clearDates() {
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }

  bool get isRangeComplete => _startDate != null && _endDate != null;

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
