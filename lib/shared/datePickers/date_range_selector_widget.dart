import 'package:app_vendedores/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'date_range_selector_controller.dart';
import 'date_range_selector_model.dart';

class DateRangeSelectorWidget extends StatelessWidget {
  final DateRangeSelectorController controller;
  
  final DateRangeSelectorModel model;
  
  final ValueChanged<DateTime> onStartDateSelected;
  
  final ValueChanged<DateTime> onEndDateSelected;
  
  final VoidCallback onClearDates;

  const DateRangeSelectorWidget({
    super.key,
    required this.controller,
    required this.model,
    required this.onStartDateSelected,
    required this.onEndDateSelected,
    required this.onClearDates,
  });

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
    final colors = GlobalTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        model.title!,
        style: colors.bodySmall.copyWith(
          color: colors.secondaryText,
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
            icon: Icon(Icons.clear, color: GlobalTheme.of(context).error),
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
    final colors = GlobalTheme.of(context);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            border: Border.all(color: colors.alternate),
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
                  style: colors.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8.0),
              Icon(
                Icons.calendar_today,
                size: 20,
                color: colors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
    final colors = GlobalTheme.of(context);
    
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
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colors.primary,
              onPrimary: colors.info,
              surface: colors.primaryBackground,
              onSurface: colors.primaryText,
            ),
            dialogBackgroundColor: colors.secondaryBackground,
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
