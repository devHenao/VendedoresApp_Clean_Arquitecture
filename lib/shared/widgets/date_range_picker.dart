import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangePicker extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime?, DateTime?) onDateRangeSelected;

  const DateRangePicker({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    required this.onDateRangeSelected,
  });

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Selecciona el rango de fechas para filtrar los reportes',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: 12.0,
                ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildDatePicker(
                context: context,
                label: 'Fecha de inicio',
                selectedDate: _startDate,
                firstDate: DateTime(2000),
                lastDate: _endDate ?? DateTime(2100),
                onDateSelected: (date) {
                  setState(() {
                    _startDate = date;
                    widget.onDateRangeSelected(_startDate, _endDate);
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildDatePicker(
                context: context,
                label: 'Fecha de fin',
                selectedDate: _endDate,
                firstDate: _startDate ?? DateTime(2000),
                lastDate: DateTime(2100),
                onDateSelected: (date) {
                  setState(() {
                    _endDate = date;
                    widget.onDateRangeSelected(_startDate, _endDate);
                  });
                },
              ),
            ),
            if (_startDate != null || _endDate != null)
              IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Theme.of(context).colorScheme.error,
                ),
                onPressed: () {
                  setState(() {
                    _startDate = null;
                    _endDate = null;
                    widget.onDateRangeSelected(null, null);
                  });
                },
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required BuildContext context,
    required String label,
    required DateTime? selectedDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required Function(DateTime) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: firstDate,
          lastDate: lastDate,
          helpText: 'Seleccione $label',
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Theme.of(context).colorScheme.primary,
                  onPrimary: Theme.of(context).colorScheme.onPrimary,
                  surface: Theme.of(context).colorScheme.surface,
                  onSurface: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? DateFormat('dd/MM/yyyy').format(selectedDate)
                  : label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Icon(
              Icons.calendar_today,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
