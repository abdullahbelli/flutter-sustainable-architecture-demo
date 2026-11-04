import 'package:flutter_test/flutter_test.dart';
import 'package:product_app/models/product.dart';

void main() {
  test('JSON fiyatı int olsa bile double olarak dönüştürülür', () {
    final product = Product.fromJson({
      'id': 1,
      'title': 'Laptop',
      'price': 25,
      'image': 'https://example.com/image.png',
    });

    expect(product.price, 25.0);
    expect(product.title, 'Laptop');
  });
}
