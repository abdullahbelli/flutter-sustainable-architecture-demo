import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductController extends ChangeNotifier {
  final ProductRepository _repository;
  ProductController(this._repository);

  List<Product> _products = const [];
  List<Product> get products => List.unmodifiable(_products);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _disposed = false;

  Future<void> loadProducts() async {
    if (_disposed || _isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final result = await _repository.getProducts();
      if (_disposed) return;
      _products = result;
    } catch (_) {
      if (_disposed) return;
      _errorMessage = 'Ürünler yüklenemedi. Tekrar deneyin.';
    } finally {
      if (!_disposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
