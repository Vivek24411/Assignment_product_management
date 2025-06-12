import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  const LoadProducts();
}

class RefreshProducts extends ProductEvent {
  const RefreshProducts();
}

class FilterProducts extends ProductEvent {
  final String? category;
  final bool? inStock;

  const FilterProducts({
    this.category,
    this.inStock,
  });

  @override
  List<Object?> get props => [category, inStock];
}

class ClearFilters extends ProductEvent {
  const ClearFilters();
} 