import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'date_range_selector_controller.dart';
import 'date_range_selector_model.dart';

/// A widget that allows users to select a date range.
/// 
/// This widget provides a clean and consistent way to select a date range
/// with start and end dates, with support for theming and customization.
class DateRangeSelectorWidget extends StatelessWidget {
  /// The controller that manages the date range selection state.
  final DateRangeSelectorController controller;
  
  /// The configuration model for the date range selector.
  final DateRangeSelectorModel model;
  
  /// Called when the start date is selected.
  final ValueChanged<DateTime> onStartDateSelected;
  
  /// Called when the end date is selected.
  final ValueChanged<DateTime> onEndDateSelected;
  
  /// Called when the clear dates button is pressed.
  final VoidCallback onClearDates;

  const DateRangeSelectorWidget({
    Key? key,
    required this.controller,
    required this.model,
    required this.onStartDateSelected,
    required this.onEndDateSelected,
    required this.onClearDates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (model.title != null) _buildTitle(context),
        const SizedBox(height: 8.0),
        _buildDateRangePicker(context),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        model.title!,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor,
            ),
      ),
    );
  }

  Widget _buildDateRangePicker(BuildContext context) {
    return Row(
      children: [
        _buildDateField(
          context,
          label: model.startDateLabel,
          selectedDate: controller.startDate,
          onTap: () => _selectDate(context, isStartDate: true),
          helpText: model.startDateHint,
          isStartDate: true,
        ),
        const SizedBox(width: 12.0),
        _buildDateField(
          context,
          label: model.endDateLabel,
          selectedDate: controller.endDate,
          onTap: () => _selectDate(context, isStartDate: false),
          helpText: model.endDateHint,
          isStartDate: false,
        ),
        if (controller.startDate != null || controller.endDate != null) ...[
          const SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.error),
            onPressed: onClearDates,
            tooltip: 'Limpiar fechas',
          ),
        ],
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
    required String helpText,
    required bool isStartDate,
  }) {
    final theme = Theme.of(context);
    final primary = model.primaryColor ?? theme.primaryColor;
    final text = model.textColor ?? theme.textTheme.bodyMedium?.color;
    final border = model.borderColor ?? theme.dividerColor;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(selectedDate)
                      : label,
                  style: theme.textTheme.bodyMedium?.copyWith(color: text),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8.0),
              Icon(
                Icons.calendar_today,
                size: 20,
                color: primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
    final theme = Theme.of(context);
    final primary = model.primaryColor ?? theme.primaryColor;
    
    final firstDate = isStartDate 
        ? DateTime(2000)
        : (controller.startDate ?? DateTime(2000));
    
    final lastDate = isStartDate 
        ? (controller.endDate ?? DateTime(2100))
        : DateTime(2100);

    final date = await showDatePicker(
      context: context,
      initialDate: isStartDate 
          ? controller.startDate ?? DateTime.now()
          : controller.endDate ?? (controller.startDate ?? DateTime.now()),
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: isStartDate ? model.startDateHint : model.endDateHint,
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: ColorScheme.light(
              primary: primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      if (isStartDate) {
        onStartDateSelected(date);
      } else {
        onEndDateSelected(date);
      }
    }
  }
}
