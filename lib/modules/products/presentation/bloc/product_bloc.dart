import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_vendedores/modules/products/domain/usecases/get_products_use_case.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;

  ProductBloc({required this.getProductsUseCase}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final failureOrProducts = await getProductsUseCase(Params(
      codprecio: event.codprecio,
      pageNumber: event.pageNumber,
      pageSize: event.pageSize,
      filter: event.filter,
    ));
    failureOrProducts.fold(
      (failure) => emit(ProductError(message: failure.props.first.toString())),
      (products) => emit(ProductLoaded(products: products)),
    );
  }
}
