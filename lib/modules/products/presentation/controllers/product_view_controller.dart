import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:app_vendedores/core/backend/schema/structs/index.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:app_vendedores/modules/auth/infrastructure/services/auth_util.dart';
import 'package:app_vendedores/modules/products/domain/usecases/get_products_use_case.dart';

class LoadResult {
  final bool success;
  final DataPageStruct? pages;
  final String? message;
  const LoadResult({required this.success, this.pages, this.message});
}

class ProductViewController {
  final FFAppState appState;
  final GetProductsUseCase? getProductsUseCase;

  // Estado de paginación y búsqueda
  DataPageStruct? pages;
  bool isLoadingNextPage = false;
  bool isLoadingPrevPage = false;
  bool isLoadingProducts = false;
  String searchFilter = '';

  ProductViewController({
    required this.appState,
    this.getProductsUseCase,
  });

  Future<LoadResult> loadProducts({
    required BuildContext context,
    String? filter,
    int? page,
    String? vendedorOverride,
  }) async {
    isLoadingProducts = true;
    final currentFilter = filter ?? searchFilter;

    final token = (appState.infoSeller.token.isNotEmpty)
        ? appState.infoSeller.token
        : (currentAuthenticationToken ?? '');
    final vendedor = (vendedorOverride != null && vendedorOverride.isNotEmpty)
        ? vendedorOverride
        : appState.dataCliente.vendedor;

    if (vendedor.isEmpty) {
      isLoadingProducts = false;
      return const LoadResult(success: false, message: 'Selecciona un cliente para ver productos (vendedor vacío).');
    }
    if (token.isEmpty) {
      isLoadingProducts = false;
      return const LoadResult(success: false, message: 'No hay token de autenticación. Inicia sesión nuevamente.');
    }

    try {
      if (getProductsUseCase != null) {
        // Usar Clean Architecture: llamar al caso de uso
        final result = await getProductsUseCase!.call(
          Params(
            vendedor: vendedor,
            pageNumber: page ?? 1,
            pageSize: 10,
            filter: currentFilter,
          ),
        );

        return result.fold(
          (failure) {
            isLoadingProducts = false;
            return LoadResult(success: false, message: failure.message);
          },
          (products) async {
            // Convertir productos del dominio a DataProductStruct para FlutterFlow
            final dataList = products.map((product) => DataProductStruct(
              codproduc: product.codproduc,
              descripcio: product.descripcio,
              codbarras: product.codbarras,
              precio: product.precio,
              saldo: product.saldo,
              selected: product.selected,
              cantidad: product.cantidad,
            )).toList();

            final merged = await actions.actualizarListaProductosCache(
              dataList,
              appState.shoppingCart.toList(),
              currentFilter,
            );
            appState.productList = merged;
            final updatedStore = await actions.updateStoreQuantity(appState.shoppingCart.toList());
            appState.store = updatedStore;

            // Crear páginas basadas en la respuesta
            pages = DataPageStruct.maybeFromMap({
              'currentPage': page ?? 1,
              'totalPages': (products.length / 10).ceil(),
              'totalCount': products.length,
              'hasNextPage': products.length >= 10,
            });

            isLoadingProducts = false;
            appState.update(() {});

            if (merged.isEmpty) {
              return LoadResult(success: true, pages: pages, message: 'No se encontraron productos para el filtro actual.');
            }
            return LoadResult(success: true, pages: pages);
          },
        );
      } else {
        // Fallback: usar implementación anterior con FlutterFlow
        // TODO: Implementar fallback o lanzar error
        isLoadingProducts = false;
        return const LoadResult(success: false, message: 'Servicio no disponible');
      }
    } catch (e) {
      isLoadingProducts = false;
      return LoadResult(success: false, message: 'Error al cargar productos: $e');
    }
  }

  Future<void> loadPreviousPage(BuildContext context, String vendedorOverride) async {
    if ((pages?.currentPage ?? 1) <= 1) return;

    await loadProducts(
      context: context,
      page: (pages?.currentPage ?? 1) - 1,
      vendedorOverride: vendedorOverride,
    );
  }

  Future<void> loadNextPage(BuildContext context, String vendedorOverride) async {
    if (pages?.hasNextPage == false) return;

    await loadProducts(
      context: context,
      page: (pages!.currentPage + 1),
      vendedorOverride: vendedorOverride,
    );
  }

  Future<void> searchProducts(BuildContext context, String filter, String vendedorOverride) async {
    searchFilter = filter;
    await loadProducts(
      context: context,
      filter: filter,
      page: 1,
      vendedorOverride: vendedorOverride,
    );
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
