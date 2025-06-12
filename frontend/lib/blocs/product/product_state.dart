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

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
} 