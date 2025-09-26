import 'package:app_vendedores/modules/products/presentation/widgets/item_product_detail/item_product_detail_widget.dart';
import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'product_detail_model.dart';

class ProductDetailHeader extends StatelessWidget {
  const ProductDetailHeader({
    super.key,
    required this.productDetails,
  });

  final List<DetailProductStruct> productDetails;

  @override
  Widget build(BuildContext context) {
    final firstItem = productDetails.isNotEmpty ? productDetails.first : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detalle de producto',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                color: FlutterFlowTheme.of(context).primaryText,
                letterSpacing: 0.0,
              ),
        ),
        const Divider(
          height: 24.0,
          thickness: 2.0,
        ),
        if (firstItem != null)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(context, 'Descripción:', firstItem.descripcio),
              _buildInfoRow(
                context,
                'Valor unitario:',
                formatNumber(
                  firstItem.precio,
                  formatType: FormatType.decimal,
                  decimalType: DecimalType.periodDecimal,
                  currency: '\$',
                ),
              ),
              _buildInfoRow(context, 'Código:', firstItem.codigo),
            ].divide(const SizedBox(height: 8)),
          ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Manrope',
                fontSize: 16.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(width: 5.0),
        Text(
          value,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Manrope',
                fontSize: 16.0,
                letterSpacing: 0.0,
              ),
        ),
      ],
    );
  }
}

class WarehouseList extends StatelessWidget {
  const WarehouseList({
    super.key,
    required this.warehouses,
    required this.itemProductDetailModels,
    required this.onQuantityChanged,
    required this.onRemoveFromWarehouse,
    required this.onSelectFromWarehouse,
  });

  final List<DetailProductStruct> warehouses;
  final ProductDetailModel itemProductDetailModels;
  final Future<void> Function(DetailProductStruct, double?) onQuantityChanged;
  final Future<void> Function(DetailProductStruct) onRemoveFromWarehouse;
  final Future<void> Function(DetailProductStruct, bool) onSelectFromWarehouse;

  @override
  Widget build(BuildContext context) {
    if (warehouses.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('Cargando...'),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: warehouses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10.0),
      itemBuilder: (context, index) {
        final warehouseItem = warehouses[index];
        return wrapWithModel(
          model: itemProductDetailModels.itemProductDetailModels.getModel(index.toString(), index),
          updateCallback: () {},
          updateOnChange: true,
          child: ItemProductDetailWidget(
            key: Key('item_${index.toString()}'),
            pCantidad: warehouseItem.cantidad,
            itemList: warehouseItem,
            callbackCantidad: (pCantidad) => onQuantityChanged(warehouseItem, pCantidad),
            callbackEliminarBodega: () => onRemoveFromWarehouse(warehouseItem),
            callbackSeleccionadoBodega: (state) => onSelectFromWarehouse(warehouseItem, state),
          ),
        );
      },
    );
  }
}

class ProductDetailActions extends StatelessWidget {
  const ProductDetailActions({
    super.key,
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FFButtonWidget(
            onPressed: onClose,
            text: 'Cerrar',
            icon: const Icon(
              Icons.close,
              size: 15.0,
            ),
            options: FFButtonOptions(
              height: 40.0,
              padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: FlutterFlowTheme.of(context).primaryBackground,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Manrope',
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                  ),
              elevation: 0.0,
              borderSide: const BorderSide(
                color: Color(0x4A161C24),
              ),
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
        ],
      ),
    );
  }
}
