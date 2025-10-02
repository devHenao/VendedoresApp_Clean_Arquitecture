import 'package:app_vendedores/modules/cart/domain/entities/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '../../../../../core/theme/theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'item_shopping_cart_model.dart';

class ProductHeader extends StatelessWidget {
  const ProductHeader({
    super.key,
    required this.item,
  });

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.descripcio,
          style: GlobalTheme.of(context).bodyMedium.override(
                fontFamily: 'Manrope',
                fontSize: 20.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildDetailItem(context, 'Código:', item.codigo),
            _buildDetailItem(context, 'Bodega:', item.bodega),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            label,
            style: GlobalTheme.of(context).bodyMedium.override(
                  fontFamily: 'Manrope',
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 5.0),
          Text(
            value,
            style: GlobalTheme.of(context).bodyMedium.override(
                  fontFamily: 'Manrope',
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }
}

class ItemActions extends StatelessWidget {
  const ItemActions({
    super.key,
    required this.onRemove,
  });

  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onRemove,
      child: FaIcon(
        FontAwesomeIcons.solidTrashCan,
        color: GlobalTheme.of(context).error,
        size: 25.0,
      ),
    );
  }
}

class QuantityControls extends StatelessWidget {
  const QuantityControls({
    super.key,
    required this.onIncrement,
    required this.onDecrement,
    required this.onQuantityChangedFromText,
    required this.controller,
    required this.focusNode,
    required this.validator,
  });

  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<String> onQuantityChangedFromText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlutterFlowIconButton(
          borderRadius: 15.0,
          buttonSize: 30.0,
          fillColor: GlobalTheme.of(context).primary,
          disabledColor: GlobalTheme.of(context).alternate,
          icon: Icon(
            Icons.remove_rounded,
            color: GlobalTheme.of(context).info,
            size: 15.0,
          ),
          onPressed: onDecrement,
        ),
        SizedBox(
          width: 100.0,
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onQuantityChangedFromText,
            autofocus: false,
            obscureText: false,
            decoration: InputDecoration(
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
            ),
            style: GlobalTheme.of(context).bodyMedium.override(
                  fontFamily: 'Manrope',
                  letterSpacing: 0.0,
                ),
            textAlign: TextAlign.center,
            maxLength: 6,
            buildCounter: (context,
                    {required currentLength, required isFocused, maxLength}) =>
                null,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            cursorColor: GlobalTheme.of(context).primaryText,
            validator: validator,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9-.]'))
            ],
          ),
        ),
        FlutterFlowIconButton(
          borderRadius: 15.0,
          buttonSize: 30.0,
          fillColor: GlobalTheme.of(context).primary,
          icon: Icon(
            Icons.add_rounded,
            color: GlobalTheme.of(context).info,
            size: 15.0,
          ),
          onPressed: onIncrement,
        ),
      ].divide(const SizedBox(width: 10.0)),
    );
  }
}

class ProductDetails extends StatelessWidget {
  const ProductDetails({
    super.key,
    required this.item,
    required this.model,
  });

  final CartItem item;
  final ItemShoppingCartModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildDetailItem(context, 'Lote:', item.codlote),
            _buildDetailItem(context, 'C. costo:', item.codcc),
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildDetailItem(context, 'Valor unitario:', model.stockLimit.toString()),
          ],
        ),
        if (model.stockLimit != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildDetailItem(context, 'Saldo:', model.stockLimit.toString()),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            label,
            style: GlobalTheme.of(context).bodyMedium.override(
                  fontFamily: 'Manrope',
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 5.0),
          Text(
            value,
            style: GlobalTheme.of(context).bodyMedium.override(
                  fontFamily: 'Manrope',
                  fontSize: 14.0,
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }
}
