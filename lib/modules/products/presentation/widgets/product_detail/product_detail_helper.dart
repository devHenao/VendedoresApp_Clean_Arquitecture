import 'package:flutter/material.dart';
import 'package:app_vendedores/modules/products/presentation/widgets/product_detail/product_detail_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:app_vendedores/app_state.dart';

class ProductDetailHelper {
  static Future<double?> showProductDetailDialog({
    required BuildContext context,
    required String codprecio,
    required String codproduc,
    double? cantidad,
  }) async {
    final result = await showDialog<double>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          alignment: const AlignmentDirectional(0.0, 0.0)
              .resolve(Directionality.of(context)),
          child: ProductDetailWidget(
            codprecio: codprecio,
            codproduc: codproduc,
            cantidad: cantidad,
            appState: FFAppState(),
          ),
        );
      },
    );

    return result;
  }
}
