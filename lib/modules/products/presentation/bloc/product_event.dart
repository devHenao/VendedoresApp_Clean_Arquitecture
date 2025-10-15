import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {
  final String vendedor;
  final int pageNumber;
  final int pageSize;
  final String filter;

  const LoadProducts({
    required this.vendedor,
    this.pageNumber = 1,
    this.pageSize = 10,
    this.filter = '',
  });

  @override
  List<Object> get props => [vendedor, pageNumber, pageSize, filter];
}
