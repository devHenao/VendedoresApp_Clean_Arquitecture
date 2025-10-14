import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:app_vendedores/core/backend/api_requests/api_calls.dart';
import 'package:app_vendedores/core/backend/schema/structs/index.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:app_vendedores/modules/auth/infrastructure/services/auth_util.dart';

class LoadResult {
  final bool success;
  final DataPageStruct? pages;
  final String? message;
  const LoadResult({required this.success, this.pages, this.message});
}

class ProductViewController {
  final FFAppState appState;
  const ProductViewController(this.appState);

  Future<LoadResult> loadProducts({
    required BuildContext context,
    required String filter,
    int? page,
    String? codprecioOverride,
  }) async {
    final token = (appState.infoSeller.token.isNotEmpty)
        ? appState.infoSeller.token
        : (currentAuthenticationToken ?? '');
    final codprecio = (codprecioOverride != null && codprecioOverride.isNotEmpty)
        ? codprecioOverride
        : appState.dataCliente.codprecio;

    if (codprecio.isEmpty) {
      return const LoadResult(success: false, message: 'Selecciona un cliente para ver productos (codprecio vacío).');
    }
    if (token.isEmpty) {
      return const LoadResult(success: false, message: 'No hay token de autenticación. Inicia sesión nuevamente.');
    }

    final apiResult = await ProductsGroup.postListProductByCodPrecioCall.call(
      token: token,
      codprecio: codprecio,
      pageNumber: page ?? 1,
      pageSize: 10,
      filter: filter,
    );

    if (apiResult.succeeded) {
      final dataList = (getJsonField(apiResult.jsonBody, r'$.data.data', true) as List?)
              ?.map((e) => DataProductStruct.maybeFromMap(e)!)
              .toList() ??
          [];
      final merged = await actions.actualizarListaProductosCache(
        dataList,
        appState.shoppingCart.toList(),
        filter,
      );
      appState.productList = merged;
      final updatedStore = await actions.updateStoreQuantity(appState.shoppingCart.toList());
      appState.store = updatedStore;
      final pages = DataPageStruct.maybeFromMap(getJsonField(apiResult.jsonBody, r'$.data'));
      if (merged.isEmpty) {
        return LoadResult(success: true, pages: pages, message: 'No se encontraron productos para el filtro actual.');
      }
      return LoadResult(success: true, pages: pages);
    } else {
      final message = getJsonField(apiResult.jsonBody, r'$.message')?.toString() ?? 'Error al cargar productos';
      return LoadResult(success: false, message: message);
    }
  }

  Future<void> onSelectedChanged(BuildContext context, DataProductStruct item, bool? state) async {
    await actions.seleccionarProducto(item, item.codproduc);
    final addProducto = await actions.agregarProducto(
      appState.dataProductList.toList(),
      item,
      state ?? false,
    );
    appState.dataProductList = addProducto;
    final listaAgregarProducto = await actions.agregarProductoCarrito(
      appState.shoppingCart.toList(),
      item,
      appState.infoSeller.storageDefault,
      '0',
      '0',
      item.cantidad,
    );
    appState.shoppingCart = listaAgregarProducto;
    final updatedStore = await actions.updateStoreQuantity(appState.shoppingCart.toList());
    appState.store = updatedStore;
    appState.update(() {});
  }

  Future<void> onQuantityChanged(BuildContext context, DataProductStruct item, double? pCantidad) async {
    final resultCache = await actions.modificarCantidad(
      item,
      appState.productList.toList(),
      pCantidad,
    );
    appState.dataProductList = resultCache;
    final listaCarrito = await actions.agregarProductoCarrito(
      appState.shoppingCart.toList(),
      item,
      appState.infoSeller.storageDefault,
      '0',
      '0',
      pCantidad,
    );
    appState.shoppingCart = listaCarrito;
    final updatedStore2 = await actions.updateStoreQuantity(appState.shoppingCart.toList());
    appState.store = updatedStore2;
    appState.update(() {});
  }

  Future<void> onDelete(BuildContext context, DataProductStruct item) async {
    final eliminado = await actions.eliminarProductoCarrito(
      appState.infoSeller.storageDefault,
      '0',
      '0',
      item.codproduc,
      appState.shoppingCart.toList(),
    );
    appState.shoppingCart = eliminado;
    final updatedStore3 = await actions.updateStoreQuantity(appState.shoppingCart.toList());
    appState.store = updatedStore3;
    appState.update(() {});
  }
}
