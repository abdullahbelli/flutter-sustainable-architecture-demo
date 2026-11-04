import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const ProductApp());

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Products - Naive Version',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        home: const ProductScreen(),
      );
}

// Bilerek tek sınıfa toplandı: API + JSON + ekran durumu + UI.
// Makalede "önce" örneği olarak kullanılacak.
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<dynamic> _products = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products'),
      );
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        throw const FormatException('Ürün listesi bekleniyordu.');
      }
      if (!mounted) return;
      setState(() => _products = decoded);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Ürünler yüklenemedi. Tekrar deneyin.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: const Text('Ürünler - Naive Version'), centerTitle: true),
        body: _buildBody(),
      );

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 12),
            FilledButton(
                onPressed: _loadProducts, child: const Text('Tekrar dene')),
          ],
        ),
      );
    }
    if (_products.isEmpty) {
      return const Center(child: Text('Henüz ürün bulunmuyor.'));
    }
    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index] as Map<String, dynamic>;
          final title = product['title'] as String;
          final price = (product['price'] as num).toDouble();
          final image = product['image'] as String;
          return Card(
            child: ListTile(
              leading: SizedBox(
                width: 52,
                height: 52,
                child: Image.network(
                  image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.shopping_bag_outlined),
                ),
              ),
              title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text('\$${price.toStringAsFixed(2)}'),
            ),
          );
        },
      ),
    );
  }
}
