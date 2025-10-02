import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import '../../../../../core/theme/theme.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProductStorageControls extends StatelessWidget {
  const ProductStorageControls({
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
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onRemove,
          child: FaIcon(
            FontAwesomeIcons.solidTrashCan,
            color: GlobalTheme.of(context).error,
            size: 20.0,
          ),
        ),
        Expanded(
          child: _buildQuantityButton(
            context,
            icon: Icons.remove_rounded,
            onPressed: isSubtractDisabled ? null : onSubtract,
          ),
        ),
        Expanded(
          child: SizedBox(
            width: 100.0,
            child: TextFormField(
              controller: textController,
              focusNode: focusNode,
              onChanged: onQuantityChanged,
              autofocus: false,
              obscureText: false,
              decoration: _buildInputDecoration(context),
              style: GlobalTheme.of(context).bodyMedium.override(
                    fontFamily: 'Manrope',
                    letterSpacing: 0.0,
                  ),
              textAlign: TextAlign.center,
              maxLength: 6,
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      maxLength}) =>
                  null,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              cursorColor: GlobalTheme.of(context).primaryText,
              validator: validator,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9-.]'))
              ],
            ),
          ),
        ),
        Expanded(
          child: _buildQuantityButton(
            context,
            icon: Icons.add_rounded,
            onPressed: isAddDisabled ? null : onAdd,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityButton(BuildContext context, {required IconData icon, VoidCallback? onPressed}) {
    return FlutterFlowIconButton(
      borderRadius: 15.0,
      buttonSize: 30.0,
      fillColor: GlobalTheme.of(context).primary,
      disabledColor: GlobalTheme.of(context).alternate,
      icon: Icon(
        icon,
        color: GlobalTheme.of(context).info,
        size: 15.0,
      ),
      onPressed: onPressed,
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    return InputDecoration(
      isDense: true,
      labelStyle: GlobalTheme.of(context).labelMedium.override(
            fontFamily: 'Manrope',
            letterSpacing: 0.0,
          ),
      hintStyle: GlobalTheme.of(context).labelMedium.override(
            fontFamily: 'Manrope',
            letterSpacing: 0.0,
          ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: GlobalTheme.of(context).secondaryText,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(0.0),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0x00000000),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(0.0),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: GlobalTheme.of(context).error,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(0.0),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: GlobalTheme.of(context).error,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(0.0),
      ),
      filled: true,
      fillColor: GlobalTheme.of(context).secondaryBackground,
    );
  }
}

class ProductStorageDetails extends StatelessWidget {
  const ProductStorageDetails({super.key, required this.item});

  final DetailProductStruct item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildDetailRow(context, 'Bodega:', item.bodega, 'bodega'),
            _buildDetailRow(context, 'Lote:', item.codlote, 'lote'),
          ],
        ),
        const SizedBox(height: 5.0),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildDetailRow(context, 'C. costo:', item.codcc, 'codccc'),
            _buildDetailRow(context, 'Saldo:', item.saldo.toString(), 'saldo'),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailRow(
      BuildContext context, String label, String? value, String defaultValue) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            label,
            style: GlobalTheme.of(context).bodyMedium.override(
                  fontFamily: 'Manrope',
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 5.0),
          Text(
            valueOrDefault<String>(value, defaultValue),
            style: GlobalTheme.of(context).bodyMedium.override(
                  fontFamily: 'Manrope',
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }
}
