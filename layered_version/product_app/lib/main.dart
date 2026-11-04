import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'controllers/product_controller.dart';
import 'repositories/api_product_repository.dart';
import 'services/product_api_service.dart';
import 'views/product_screen.dart';

void main() => runApp(const ProductApp());

class ProductApp extends StatefulWidget {
  const ProductApp({super.key});

  @override
  State<ProductApp> createState() => _ProductAppState();
}

class _ProductAppState extends State<ProductApp> {
  late final http.Client _client;
  late final ProductController _controller;

  @override
  void initState() {
    super.initState();
    // Composition Root: bağımlılıkları burada oluşturup dışarıdan veriyoruz.
    _client = http.Client();
    final service = ProductApiService(_client);
    final repository = ApiProductRepository(service);
    _controller = ProductController(repository);
  }

  @override
  void dispose() {
    _controller.dispose();
    _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Products - Layered Architecture',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        home: ProductScreen(controller: _controller),
      );
}
