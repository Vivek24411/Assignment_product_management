import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../blocs/product/product_state.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class EditProductPage extends StatelessWidget {
  final String productId;

  const EditProductPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(
        productRepository: ProductRepository(),
      )..add(LoadProduct(productId)),
      child: EditProductView(productId: productId),
    );
  }
}

class EditProductView extends StatefulWidget {
  final String productId;

  const EditProductView({
    super.key,
    required this.productId,
  });

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  String? _selectedCategory;
  bool _isCustomCategory = false;
  final _customCategoryController = TextEditingController();
  Product? _originalProduct;

  final List<String> _categories = [
    'Electronics',
    'Clothing',
    'Books',
    'Home & Garden',
    'Sports',
    'Toys',
    'Food & Beverages',
    'Health & Beauty',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  void _populateForm(Product product) {
    _originalProduct = product;
    _nameController.text = product.name;
    _quantityController.text = product.quantity.toString();
    _priceController.text = product.price.toString();

    if (_categories.contains(product.category)) {
      _selectedCategory = product.category;
      _isCustomCategory = false;
    } else {
      _isCustomCategory = true;
      _customCategoryController.text = product.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is ProductUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Product "${state.product.name}" updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is SingleProductLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading product',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(LoadProduct(widget.productId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is SingleProductLoaded) {
            if (_originalProduct == null) {
              _populateForm(state.product);
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit Product Information',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Product Name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.inventory_2),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a product name';
                                }
                                if (value.trim().length < 2) {
                                  return 'Product name must be at least 2 characters';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _isCustomCategory
                                      ? TextFormField(
                                          controller: _customCategoryController,
                                          decoration: const InputDecoration(
                                            labelText: 'Custom Category',
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.category),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.trim().isEmpty) {
                                              return 'Please enter a category';
                                            }
                                            return null;
                                          },
                                          textInputAction: TextInputAction.next,
                                        )
                                      : DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            labelText: 'Category',
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.category),
                                          ),
                                          value: _selectedCategory,
                                          hint: const Text('Select a category'),
                                          items: [
                                            ..._categories.map((category) => DropdownMenuItem<String>(
                                              value: category,
                                              child: Text(category),
                                            )),
                                            const DropdownMenuItem<String>(
                                              value: 'custom',
                                              child: Text('Custom Category'),
                                            ),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == 'custom') {
                                                _isCustomCategory = true;
                                                _selectedCategory = null;
                                              } else {
                                                _isCustomCategory = false;
                                                _selectedCategory = value;
                                              }
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please select a category';
                                            }
                                            return null;
                                          },
                                        ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _quantityController,
                                    decoration: const InputDecoration(
                                      labelText: 'Quantity',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.numbers),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter quantity';
                                      }
                                      final quantity = int.tryParse(value);
                                      if (quantity == null || quantity < 0) {
                                        return 'Please enter a valid quantity';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _priceController,
                                    decoration: const InputDecoration(
                                      labelText: 'Price (\$)',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.attach_money),
                                    ),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter price';
                                      }
                                      final price = double.tryParse(value);
                                      if (price == null || price < 0) {
                                        return 'Please enter a valid price';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.cancel),
                            label: const Text('Cancel'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: state is ProductUpdating ? null : _updateProduct,
                            icon: state is ProductUpdating
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.save),
                            label: Text(
                              state is ProductUpdating ? 'Updating...' : 'Update Product',
                            ),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void _updateProduct() {
    if (_formKey.currentState!.validate() && _originalProduct != null) {
      final name = _nameController.text.trim();
      final category = _isCustomCategory
          ? _customCategoryController.text.trim()
          : _selectedCategory!;
      final quantity = int.parse(_quantityController.text);
      final price = double.parse(_priceController.text);

      final updatedProduct = _originalProduct!.copyWith(
        name: name,
        category: category,
        quantity: quantity,
        price: price,
      );

      context.read<ProductBloc>().add(UpdateProduct(updatedProduct));
    }
  }
} 