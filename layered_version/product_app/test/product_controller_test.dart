import 'package:flutter_test/flutter_test.dart';
import 'package:product_app/controllers/product_controller.dart';

import 'fakes/fake_product_repository.dart';

void main() {
  test('Başarılı: ürünleri yükler ve hatayı boş bırakır', () async {
    final controller = ProductController(FakeProductRepository());
    addTearDown(controller.dispose);

    await controller.loadProducts();

    expect(controller.products.length, 2);
    expect(controller.products.first.title, 'Laptop');
    expect(controller.isLoading, isFalse);
    expect(controller.errorMessage, isNull);
  });

  test('Hatalı: kullanıcıya hata durumunu iletir', () async {
    final controller = ProductController(
      FakeProductRepository(shouldFail: true),
    );
    addTearDown(controller.dispose);

    await controller.loadProducts();

    expect(controller.isLoading, isFalse);
    expect(controller.errorMessage, isNotNull);
    expect(controller.products, isEmpty);
  });

  test('Dinleyicilere yükleme başında ve sonunda bildirim gider', () async {
    final controller = ProductController(FakeProductRepository());
    addTearDown(controller.dispose);
    final observedLoading = <bool>[];
    controller.addListener(() => observedLoading.add(controller.isLoading));

    await controller.loadProducts();

    expect(observedLoading, [true, false]);
  });
}
