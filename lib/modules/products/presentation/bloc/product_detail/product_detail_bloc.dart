import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_vendedores/core/backend/api_requests/api_calls.dart';
import 'package:app_vendedores/core/backend/schema/structs/index.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_util.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final FFAppState appState;

  ProductDetailBloc({required this.appState}) : super(ProductDetailInitial()) {
    on<LoadProductDetail>(_onLoadProductDetail);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<RemoveFromWarehouse>(_onRemoveFromWarehouse);
    on<SelectFromWarehouse>(_onSelectFromWarehouse);
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(ProductDetailLoading());

    final apiResult = await ProductsGroup.getListStorageByProductCall.call(
      token: appState.infoSeller.token,
      codprecio: event.codprecio,
      codproduc: event.codproduc,
    );

    if (apiResult.succeeded) {
      final apiData = getJsonField(apiResult.jsonBody, r'''$.data''', true);
      final initialList = (apiData as List?)
          ?.map((e) => DetailProductStruct.maybeFromMap(e)!)
          .toList() ??
          [];

      final updatedList = await actions.actualizarListaProductosBodega(
        initialList,
        appState.shoppingCart.toList(),
      );

      emit(ProductDetailLoaded(
        warehouses: updatedList ?? [],
      ));
    } else {
      emit(ProductDetailError(
        message: getJsonField(apiResult.jsonBody, r'''$.message''').toString(),
      ));
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<ProductDetailState> emit,
  ) async {
    if (state is! ProductDetailLoaded) return;

    final currentState = state as ProductDetailLoaded;

    emit(currentState.copyWith(isSubmitting: true));

    try {
      final updatedList = await actions.modificarCantidadBodega(
        currentState.warehouses.firstWhere((item) => item.toString() == event.item),
        currentState.warehouses,
        event.quantity,
      );

      final item = currentState.warehouses.firstWhere((item) => item.toString() == event.item);

      final updatedCart = await actions.agregarProductoCarrito(
        appState.shoppingCart.toList(),
        _createDataProductStruct(item),
        item.bodega,
        item.codcc,
        item.codlote,
        item.cantidad,
      );
      appState.shoppingCart = updatedCart ?? [];

      final updatedStore = await actions.updateStoreQuantity(appState.shoppingCart.toList());
      appState.store = updatedStore ?? [];

      emit(currentState.copyWith(
        warehouses: updatedList ?? currentState.warehouses,
        isSubmitting: false,
      ));
    } catch (e) {
      emit(currentState.copyWith(
        isSubmitting: false,
        errorMessage: 'Error al actualizar cantidad: $e',
      ));
    }
  }

  Future<void> _onRemoveFromWarehouse(
    RemoveFromWarehouse event,
    Emitter<ProductDetailState> emit,
  ) async {
    if (state is! ProductDetailLoaded) return;

    final currentState = state as ProductDetailLoaded;

    emit(currentState.copyWith(isSubmitting: true));

    try {
      final item = currentState.warehouses.firstWhere((item) => item.toString() == event.item);

      final updatedCart = await actions.eliminarProductoCarrito(
        item.bodega,
        item.codcc,
        item.codlote,
        item.codigo,
        appState.shoppingCart.toList(),
      );
      appState.shoppingCart = updatedCart ?? [];

      final updatedStore = await actions.updateStoreQuantity(appState.shoppingCart.toList());
      appState.store = updatedStore ?? [];

      emit(currentState.copyWith(isSubmitting: false));
    } catch (e) {
      emit(currentState.copyWith(
        isSubmitting: false,
        errorMessage: 'Error al remover de bodega: $e',
      ));
    }
  }

  Future<void> _onSelectFromWarehouse(
    SelectFromWarehouse event,
    Emitter<ProductDetailState> emit,
  ) async {
    if (state is! ProductDetailLoaded) return;

    final currentState = state as ProductDetailLoaded;

    emit(currentState.copyWith(isSubmitting: true));

    try {
      if (event.selected) {
        final item = currentState.warehouses.firstWhere((item) => item.toString() == event.item);

        final updatedCart = await actions.agregarProductoCarrito(
          appState.shoppingCart.toList(),
          _createDataProductStruct(item),
          item.bodega,
          item.codcc,
          item.codlote,
          item.cantidad,
        );
        appState.shoppingCart = updatedCart ?? [];

        final updatedStore = await actions.updateStoreQuantity(appState.shoppingCart.toList());
        appState.store = updatedStore ?? [];
      }

      emit(currentState.copyWith(isSubmitting: false));
    } catch (e) {
      emit(currentState.copyWith(
        isSubmitting: false,
        errorMessage: 'Error al seleccionar de bodega: $e',
      ));
    }
  }

  DataProductStruct _createDataProductStruct(DetailProductStruct item) {
    return DataProductStruct(
      codproduc: item.codigo,
      precio: item.precio,
      descripcio: item.descripcio,
      selected: true,
      saldo: item.saldo,
      cantidad: item.cantidad,
      unidadmed: item.unidadmed,
      codtariva: item.codtariva,
      iva: item.iva,
      codbarras: '',
    );
  }
}
