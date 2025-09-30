import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeSelector extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime> onStartDateSelected;
  final ValueChanged<DateTime> onEndDateSelected;
  final VoidCallback onClearDates;
  final Color? primaryColor;
  final Color? textColor;
  final Color? borderColor;
  final String? title;
  final String startDateLabel;
  final String endDateLabel;
  final String startDateHint;
  final String endDateHint;

  const DateRangeSelector({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateSelected,
    required this.onEndDateSelected,
    required this.onClearDates,
    this.primaryColor,
    this.textColor,
    this.borderColor,
    this.title = 'Selecciona el rango de fechas',
    this.startDateLabel = 'Fecha de inicio',
    this.endDateLabel = 'Fecha de fin',
    this.startDateHint = 'Seleccione fecha inicial',
    this.endDateHint = 'Seleccione fecha final',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = primaryColor ?? theme.primaryColor;
    final text = textColor ?? theme.textTheme.bodyMedium?.color;
    final border = borderColor ?? theme.dividerColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ),
          const SizedBox(height: 4.0),
        ],
        Row(
          children: [
            Expanded(
              child: _DatePickerField(
                label: startDateLabel,
                selectedDate: startDate,
                onDateSelected: onStartDateSelected,
                firstDate: DateTime(2000),
                lastDate: endDate ?? DateTime(2100),
                primaryColor: primary,
                textColor: text,
                borderColor: border,
                helpText: startDateHint,
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: _DatePickerField(
                label: endDateLabel,
                selectedDate: endDate,
                onDateSelected: onEndDateSelected,
                firstDate: startDate ?? DateTime(2000),
                lastDate: DateTime(2100),
                textColor: text,
                borderColor: border,
                helpText: endDateHint,
              ),
            ),
            if (startDate != null || endDate != null) ...[
              const SizedBox(width: 8.0),
              IconButton(
                icon: Icon(Icons.clear, color: theme.colorScheme.error),
                onPressed: onClearDates,
                tooltip: 'Limpiar fechas',
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime firstDate;
  final DateTime lastDate;
  final String helpText;
  final Color? primaryColor;
  final Color? textColor;
  final Color? borderColor;

  const _DatePickerField({
    Key? key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    required this.firstDate,
    required this.lastDate,
    required this.helpText,
    this.primaryColor,
    this.textColor,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = primaryColor ?? theme.primaryColor;
    final text = textColor ?? theme.textTheme.bodyMedium?.color;
    final border = borderColor ?? theme.dividerColor;

    return InkWell(
      onTap: () => _selectDate(context),
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
                    ? DateFormat('dd/MM/yyyy').format(selectedDate!)
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
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final theme = Theme.of(context);
    final primary = primaryColor ?? theme.primaryColor;
    
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: helpText,
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
      onDateSelected(date);
    }
  }
}
