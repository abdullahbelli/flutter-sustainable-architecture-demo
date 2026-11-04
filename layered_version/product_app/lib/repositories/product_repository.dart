import '../models/product.dart';

// Üst seviye bileşenler somut API uygulamasına değil, bu sözleşmeye bağlıdır.
abstract interface class ProductRepository {
  Future<List<Product>> getProducts();
}
