import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class DateRangePickerModel extends FlutterFlowModel {
  DateTime? startDate;
  DateTime? endDate;
  
  @override
  void initState(BuildContext context) {
    startDate = null;
    endDate = null;
  }

  @override
  void dispose() {
    // Limpiar recursos si es necesario
  }
  
  void setDateRange(DateTime? start, DateTime? end) {
    startDate = start;
    endDate = end;
  }
  
  String getFormattedDateRange() {
    if (startDate == null || endDate == null) {
      return 'Seleccionar rango de fechas';
    }
    
    final startFormat = DateFormat('dd/MM/yyyy').format(startDate!);
    final endFormat = DateFormat('dd/MM/yyyy').format(endDate!);
    
    return '$startFormat - $endFormat';
  }
}
