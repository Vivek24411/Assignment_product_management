import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? selectedCategory;
  bool? inStockFilter;

  final List<String> categories = [
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
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Products'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            value: selectedCategory,
            hint: const Text('All Categories'),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('All Categories'),
              ),
              ...categories.map((category) => DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              )),
            ],
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<bool>(
            decoration: const InputDecoration(
              labelText: 'Stock Status',
              border: OutlineInputBorder(),
            ),
            value: inStockFilter,
            hint: const Text('All Products'),
            items: const [
              DropdownMenuItem<bool>(
                value: null,
                child: Text('All Products'),
              ),
              DropdownMenuItem<bool>(
                value: true,
                child: Text('In Stock'),
              ),
              DropdownMenuItem<bool>(
                value: false,
                child: Text('Out of Stock'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                inStockFilter = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            context.read<ProductBloc>().add(
              FilterProducts(
                category: selectedCategory,
                inStock: inStockFilter,
              ),
            );
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
} 