import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import '../../../../../core/theme/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Icon(
        Icons.add_circle_sharp,
        color: FlutterFlowTheme.of(context).primary,
        size: 40.0,
      ),
    );
  }
}

class QuantityControls extends StatelessWidget {
  const QuantityControls({
    super.key,
    required this.onRemove,
    required this.onSubtract,
    required this.onAdd,
    required this.onQuantityChanged,
    required this.textController,
    required this.focusNode,
    required this.validator,
    this.isSubtractDisabled = false,
    this.isAddDisabled = false,
  });

  final VoidCallback onRemove;
  final VoidCallback onSubtract;
  final VoidCallback onAdd;
  final void Function(String) onQuantityChanged;
  final TextEditingController textController;
  final FocusNode focusNode;
  final FormFieldValidator<String>? validator;
  final bool isSubtractDisabled;
  final bool isAddDisabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onRemove,
          child: FaIcon(
            FontAwesomeIcons.solidTrashCan,
            color: FlutterFlowTheme.of(context).error,
            size: 24.0,
          ),
        ),
        Expanded(
          child: _buildIconButton(context, Icons.remove_rounded, isSubtractDisabled ? null : onSubtract),
        ),
        Expanded(
          child: SizedBox(
            width: 100.0,
            child: TextFormField(
              controller: textController,
              focusNode: focusNode,
              onChanged: onQuantityChanged,
              textAlign: TextAlign.center,
              decoration: _buildInputDecoration(context),
              // ... otros parámetros del TextFormField ...
            ),
          ),
        ),
        Expanded(
          child: _buildIconButton(context, Icons.add_rounded, isAddDisabled ? null : onAdd),
        ),
      ],
    );
  }

  Widget _buildIconButton(BuildContext context, IconData icon, VoidCallback? onPressed) {
    return FlutterFlowIconButton(
      borderRadius: 15.0,
      buttonSize: 30.0,
      fillColor: FlutterFlowTheme.of(context).primary,
      disabledColor: FlutterFlowTheme.of(context).alternate,
      icon: Icon(icon, color: FlutterFlowTheme.of(context).info, size: 15.0),
      onPressed: onPressed,
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    return InputDecoration(
      isDense: true,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: FlutterFlowTheme.of(context).secondaryText, width: 1.0),
        borderRadius: BorderRadius.circular(0.0),
      ),
      // ... otras decoraciones ...
    );
  }
}

class ProductActions extends StatelessWidget {
  const ProductActions({
    super.key,
    required this.selecionado,
    required this.saldo,
    required this.onAdd, // Callback for the simple add button
    // Callbacks and controllers for the detailed quantity controls
    required this.onRemove,
    required this.onSubtract,
    required this.onIncrement,
    required this.onQuantityChanged,
    required this.textController,
    required this.focusNode,
    required this.validator,
    required this.contador,
    required this.saldoBodegaVendedor,
  });

  final bool? selecionado;
  final double saldo;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onSubtract;
  final VoidCallback onIncrement;
  final void Function(String) onQuantityChanged;
  final TextEditingController textController;
  final FocusNode focusNode;
  final FormFieldValidator<String>? validator;
  final double? contador;
  final double? saldoBodegaVendedor;

  @override
  Widget build(BuildContext context) {
    if (selecionado == true) {
      // --- VISTA CUANDO EL PRODUCTO ESTÁ SELECCIONADO ---
      return QuantityControls(
        onRemove: onRemove,
        onSubtract: onSubtract,
        onAdd: onIncrement,
        onQuantityChanged: onQuantityChanged,
        textController: textController,
        focusNode: focusNode,
        validator: validator,
        isSubtractDisabled: (contador ?? 0) <= 0,
        isAddDisabled: (contador ?? 0) >= (saldoBodegaVendedor ?? double.infinity),
      );
    } else {
      // --- VISTA CUANDO EL PRODUCTO NO ESTÁ SELECCIONADO ---
      if (saldo <= 0) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).error.withAlpha(230),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            'Sin Stock',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Manrope',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
          ),
        );
      } else {
        return AddButton(onTap: onAdd);
      }
    }
  }
}

class ProductInfo extends StatelessWidget {
  const ProductInfo({
    super.key,
    required this.productItem,
    required this.precio,
    required this.saldo,
  });

  final DataProductStruct? productItem;
  final double precio;
  final double saldo;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          valueOrDefault<String>(
            formatNumber(
              precio,
              formatType: FormatType.decimal,
              decimalType: DecimalType.periodDecimal,
              currency: '\$',
            ),
            '-',
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Manrope',
                fontSize: 20.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 9.0, 0.0),
          child: Text(
            valueOrDefault<String>(
              productItem?.descripcio,
              '-',
            ).maybeHandleOverflow(
              maxChars: 75,
              replacement: '…',
            ),
            maxLines: 2,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Manrope',
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Código:',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Manrope',
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              valueOrDefault<String>(
                productItem?.codproduc,
                '-',
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Manrope',
                    letterSpacing: 0.0,
                  ),
            ),
          ].divide(const SizedBox(width: 5.0)),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Saldo:',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Manrope',
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              valueOrDefault<String>(
                saldo.toString(),
                '0',
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Manrope',
                    letterSpacing: 0.0,
                  ),
            ),
          ].divide(const SizedBox(width: 5.0)),
        ),
      ].divide(const SizedBox(height: 5.0)),
    );
  }
}
