import 'package:flutter/material.dart';

import '../controllers/product_controller.dart';

class ProductScreen extends StatefulWidget {
  final ProductController controller;

  const ProductScreen({super.key, required this.controller});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.loadProducts();
  }

  @override
  void didUpdateWidget(covariant ProductScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      widget.controller.loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Ürünler'), centerTitle: true),
        body: ListenableBuilder(
          listenable: widget.controller,
          builder: (context, _) {
            final controller = widget.controller;
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(controller.errorMessage!),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: controller.loadProducts,
                      child: const Text('Tekrar dene'),
                    ),
                  ],
                ),
              );
            }
            final products = controller.products;
            if (products.isEmpty) {
              return const Center(child: Text('Henüz ürün bulunmuyor.'));
            }
            return RefreshIndicator(
              onRefresh: controller.loadProducts,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    child: ListTile(
                      leading: SizedBox(
                        width: 52,
                        height: 52,
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.shopping_bag_outlined),
                        ),
                      ),
                      title: Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
}
