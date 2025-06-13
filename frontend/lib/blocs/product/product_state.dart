import 'package:equatable/equatable.dart';
import '../../models/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final String? selectedCategory;
  final bool? inStockFilter;

  const ProductLoaded({
    required this.products,
    this.selectedCategory,
    this.inStockFilter,
  });

  @override
  List<Object?> get props => [products, selectedCategory, inStockFilter];

  ProductLoaded copyWith({
    List<Product>? products,
    String? selectedCategory,
    bool? inStockFilter,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      inStockFilter: inStockFilter ?? this.inStockFilter,
    );
  }
}

class SingleProductLoading extends ProductState {}

class SingleProductLoaded extends ProductState {
  final Product product;

  const SingleProductLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductDeleting extends ProductState {}

class ProductDeleted extends ProductState {
  final int productId;

  const ProductDeleted(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ProductCreating extends ProductState {}

class ProductCreated extends ProductState {
  final Product product;

  const ProductCreated(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductUpdating extends ProductState {}

class ProductUpdated extends ProductState {
  final Product product;

  const ProductUpdated(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
} 