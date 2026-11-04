import 'package:product_app/models/product.dart';
import 'package:product_app/repositories/product_repository.dart';

class FakeProductRepository implements ProductRepository {
  final List<Product> sampleProducts;
  final bool shouldFail;

  FakeProductRepository({
    this.sampleProducts = const [
      Product(id: 1, title: 'Laptop', price: 25000, imageUrl: ''),
      Product(id: 2, title: 'Telefon', price: 15000, imageUrl: ''),
    ],
    this.shouldFail = false,
  });

  @override
  Future<List<Product>> getProducts() async {
    if (shouldFail) throw Exception('Test hatası');
    return sampleProducts;
  }
}
