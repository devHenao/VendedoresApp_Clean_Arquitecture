import 'package:flutter/material.dart';
import 'date_range_picker_widget.dart';

class DateRangePickerController {
  static Future<void> showDateRangePickerDialog({
    required BuildContext context,
    DateTime? initialStartDate,
    DateTime? initialEndDate,
    required Function(DateTime?, DateTime?) onDateRangeSelected,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => DateRangePickerWidget(
        initialStartDate: initialStartDate,
        initialEndDate: initialEndDate,
        onDateRangeSelected: onDateRangeSelected,
      ),
    );
  }
}
