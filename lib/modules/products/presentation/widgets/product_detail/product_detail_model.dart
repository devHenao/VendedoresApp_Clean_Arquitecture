import 'package:app_vendedores/core/backend/api_requests/_/api_manager.dart';
import 'package:app_vendedores/modules/products/presentation/widgets/item_product_detail/item_product_detail_model.dart';
import '../../../../../core/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'product_detail_widget.dart' show ProductDetailWidget;
import 'package:flutter/material.dart';

class ProductDetailModel extends FlutterFlowModel<ProductDetailWidget> {
  ///  Local state fields for this component.

  List<DetailProductStruct> listDetail = [];
  void addToListDetail(DetailProductStruct item) => listDetail.add(item);
  void removeFromListDetail(DetailProductStruct item) =>
      listDetail.remove(item);
  void removeAtIndexFromListDetail(int index) => listDetail.removeAt(index);
  void insertAtIndexInListDetail(int index, DetailProductStruct item) =>
      listDetail.insert(index, item);
  void updateListDetailAtIndex(
          int index, Function(DetailProductStruct) updateFn) =>
      listDetail[index] = updateFn(listDetail[index]);

  List<DetailProductStruct> toCartList = [];
  void addToToCartList(DetailProductStruct item) => toCartList.add(item);
  void removeFromToCartList(DetailProductStruct item) =>
      toCartList.remove(item);
  void removeAtIndexFromToCartList(int index) => toCartList.removeAt(index);
  void insertAtIndexInToCartList(int index, DetailProductStruct item) =>
      toCartList.insert(index, item);
  void updateToCartListAtIndex(
          int index, Function(DetailProductStruct) updateFn) =>
      toCartList[index] = updateFn(toCartList[index]);

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (getListStorageByProduct)] action in ProductDetail widget.
  ApiCallResponse? apiResultDetail;
  // Stores action output result for [Custom Action - actualizarListaProductosBodega] action in ProductDetail widget.
  List<DetailProductStruct>? resultadoBodega;
  // Models for ItemProductDetail dynamic component.
  late FlutterFlowDynamicModels<ItemProductDetailModel> itemProductDetailModels;
  // Stores action output result for [Custom Action - modificarCantidadBodega] action in ItemProductDetail widget.
  List<DetailProductStruct>? resultadoCantidad;
  // Stores action output result for [Custom Action - agregarProductoCarrito] action in ItemProductDetail widget.
  List<DetailProductStruct>? resultadoCarrito;
  // Stores action output result for [Custom Action - updateStoreQuantity] action in ItemProductDetail widget.
  List<DetailProductStruct>? updatedStore;
  // Stores action output result for [Custom Action - eliminarProductoCarrito] action in ItemProductDetail widget.
  List<DetailProductStruct>? resultadoEliminarBodega;
  // Stores action output result for [Custom Action - updateStoreQuantity] action in ItemProductDetail widget.
  List<DetailProductStruct>? updatedStore2;
  // Stores action output result for [Custom Action - eliminarProductoCarrito] action in ItemProductDetail widget.
  List<DetailProductStruct>? resultadoEliminarBodega2;
  // Stores action output result for [Custom Action - updateStoreQuantity] action in ItemProductDetail widget.
  List<DetailProductStruct>? updatedStore3;
  // Stores action output result for [Custom Action - seleccionarProducto] action in ItemProductDetail widget.
  DataProductStruct? resultBodega;
  // Stores action output result for [Custom Action - agregarProductoCarrito] action in ItemProductDetail widget.
  List<DetailProductStruct>? addProduct;
  // Stores action output result for [Custom Action - updateStoreQuantity] action in ItemProductDetail widget.
  List<DetailProductStruct>? updatedStore4;
  // Stores action output result for [Custom Action - deleteProduct] action in ItemProductDetail widget.
  List<DetailProductStruct>? deleteProduct;
  // Local state field to hold the updated quantity from the seller's default storage.
  double? updatedQuantityForCallback;

  @override
  void initState(BuildContext context) {
    itemProductDetailModels =
        FlutterFlowDynamicModels(() => ItemProductDetailModel());
  }

  @override
  void dispose() {
    itemProductDetailModels.dispose();
  }
}
