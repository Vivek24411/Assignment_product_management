import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProduct>(_onLoadProduct);
    on<RefreshProducts>(_onRefreshProducts);
    on<FilterProducts>(_onFilterProducts);
    on<ClearFilters>(_onClearFilters);
    on<DeleteProduct>(_onDeleteProduct);
    on<CreateProduct>(_onCreateProduct);
    on<UpdateProduct>(_onUpdateProduct);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _productRepository.getProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadProduct(
    LoadProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(SingleProductLoading());
    try {
      final product = await _productRepository.getProduct(event.id);
      emit(SingleProductLoaded(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      try {
        final products = await _productRepository.getProducts(
          category: currentState.selectedCategory,
          inStock: currentState.inStockFilter,
        );
        emit(ProductLoaded(
          products: products,
          selectedCategory: currentState.selectedCategory,
          inStockFilter: currentState.inStockFilter,
        ));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    }
  }

  Future<void> _onFilterProducts(
    FilterProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _productRepository.getProducts(
        category: event.category,
        inStock: event.inStock,
        stockFilter: event.stockFilter,
      );
      emit(ProductLoaded(
        products: products,
        selectedCategory: event.category,
        inStockFilter: event.inStock,
      ));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onClearFilters(
    ClearFilters event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _productRepository.getProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductDeleting());
    try {
      await _productRepository.deleteProduct(event.id);
      emit(ProductDeleted(event.id));
      final products = await _productRepository.getProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onCreateProduct(
    CreateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductCreating());
    try {
      final createdProduct = await _productRepository.createProduct(event.product);
      emit(ProductCreated(createdProduct));
      final products = await _productRepository.getProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductUpdating());
    try {
      final updatedProduct = await _productRepository.updateProduct(event.product);
      emit(ProductUpdated(updatedProduct));
      final products = await _productRepository.getProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
} 