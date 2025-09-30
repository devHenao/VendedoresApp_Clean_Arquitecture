import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_vendedores/modules/cart/domain/usecases/cart_use_cases.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUseCase getCartItemsUseCase;
  final AddItemUseCase addItemUseCase;
  final RemoveItemUseCase removeItemUseCase;
  final UpdateItemQuantityUseCase updateItemQuantityUseCase;
  final ClearCartUseCase clearCartUseCase;
  final PlaceOrderUseCase placeOrderUseCase;

  CartBloc({
    required this.getCartItemsUseCase,
    required this.addItemUseCase,
    required this.removeItemUseCase,
    required this.updateItemQuantityUseCase,
    required this.clearCartUseCase,
    required this.placeOrderUseCase,
  }) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
    on<UpdateItemQuantity>(_onUpdateItemQuantity);
    on<ClearCart>(_onClearCart);
    on<PlaceOrder>(_onPlaceOrder);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    final failureOrItems = await getCartItemsUseCase();
    failureOrItems.fold(
      (failure) => emit(CartError(message: failure.props.first.toString())),
      (items) {
        final total = items.fold(0.0, (sum, item) => sum + (item.precio * item.cantidad));
        emit(CartLoaded(items: items, total: total));
      },
    );
  }

  Future<void> _onAddItem(AddItem event, Emitter<CartState> emit) async {
    await addItemUseCase(event.item);
    add(LoadCart());
  }

  Future<void> _onRemoveItem(RemoveItem event, Emitter<CartState> emit) async {
    await removeItemUseCase(event.itemCode);
    add(LoadCart());
  }

  Future<void> _onUpdateItemQuantity(UpdateItemQuantity event, Emitter<CartState> emit) async {
    await updateItemQuantityUseCase(event.itemCode, event.quantity);
    add(LoadCart());
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    await clearCartUseCase();
    add(LoadCart());
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<CartState> emit) async {
    if (state is CartLoaded) {
      final items = (state as CartLoaded).items;
      if (items.isNotEmpty) {
        emit(CartLoading());
        final failureOrSuccess = await placeOrderUseCase(event.nit, items);
        failureOrSuccess.fold(
          (failure) => emit(OrderPlacementFailure(message: failure.props.first.toString())),
          (_) => emit(OrderPlacementSuccess()),
        );
        add(LoadCart());
      }
    }
  }
}
