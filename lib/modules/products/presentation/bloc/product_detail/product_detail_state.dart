import 'package:equatable/equatable.dart';
import 'package:app_vendedores/core/backend/schema/structs/index.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final List<DetailProductStruct> warehouses;
  final bool isSubmitting;
  final String? errorMessage;

  const ProductDetailLoaded({
    required this.warehouses,
    this.isSubmitting = false,
    this.errorMessage,
  });

  ProductDetailLoaded copyWith({
    List<DetailProductStruct>? warehouses,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return ProductDetailLoaded(
      warehouses: warehouses ?? this.warehouses,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [warehouses, isSubmitting, errorMessage];
}

class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProductDetailSuccess extends ProductDetailState {
  final double quantityForCallback;

  const ProductDetailSuccess({required this.quantityForCallback});

  @override
  List<Object?> get props => [quantityForCallback];
}
