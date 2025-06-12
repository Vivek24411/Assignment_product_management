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
  String? stockFilter;

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
      title: Row(
        children: [
          const Icon(Icons.filter_list),
          const SizedBox(width: 8),
          const Text('Filter Products'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.category),
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
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Stock Status',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.inventory_2),
            ),
            value: stockFilter,
            hint: const Text('All Products'),
            items: const [
              DropdownMenuItem<String>(
                value: null,
                child: Text('All Products'),
              ),
              DropdownMenuItem<String>(
                value: 'in_stock',
                child: Text('In Stock'),
              ),
              DropdownMenuItem<String>(
                value: 'low_stock',
                child: Text('Low Stock'),
              ),
              DropdownMenuItem<String>(
                value: 'out_of_stock',
                child: Text('Out of Stock'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                stockFilter = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _resetFilters,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ),
            ],
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
        FilledButton.icon(
          onPressed: _applyFilters,
          icon: const Icon(Icons.check),
          label: const Text('Apply'),
        ),
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      selectedCategory = null;
      stockFilter = null;
    });
  }

  void _applyFilters() {
    context.read<ProductBloc>().add(
      FilterProducts(
        category: selectedCategory,
        stockFilter: stockFilter,
      ),
    );
    Navigator.of(context).pop();
  }
} 