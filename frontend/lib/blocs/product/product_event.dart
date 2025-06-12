import 'package:equatable/equatable.dart';
import '../../models/product.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  const LoadProducts();
}

class LoadProduct extends ProductEvent {
  final String id;

  const LoadProduct(this.id);

  @override
  List<Object?> get props => [id];
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

class DeleteProduct extends ProductEvent {
  final String id;

  const DeleteProduct(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateProduct extends ProductEvent {
  final Product product;

  const CreateProduct(this.product);

  @override
  List<Object?> get props => [product];
} 