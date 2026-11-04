import '../models/product.dart';
import '../services/product_api_service.dart';
import 'product_repository.dart';

class ApiProductRepository implements ProductRepository {
  final ProductApiService _service;

  ApiProductRepository(this._service);

  @override
  Future<List<Product>> getProducts() async {
    final raw = await _service.fetchProducts();
    return raw
        .map((item) => Product.fromJson(
              Map<String, dynamic>.from(item as Map),
            ))
        .toList();
  }
}
