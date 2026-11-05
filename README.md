# Flutter'da Sürdürülebilir Mimari — Örnek Proje

Bu depo, **aynı Fake Store API ürün listeleme uygulamasının iki farklı mimariyle** yazılmış sürümünü içerir. Medium'daki *Flutter'da Sürdürülebilir Mimari: Design Patterns, Repository Pattern ve Dependency Injection* makalesi için hazırlanmıştır.

- **Naive Version:** Bir `StatefulWidget` içinde HTTP, JSON dönüştürme, `setState` ve arayüz.
- **Layered Version:** Model, Service, Repository sözleşmesi ve uygulaması, Controller (`ChangeNotifier`) ve View (`ListenableBuilder`); bağımlılıklar `main.dart` içinde Constructor Injection ile bağlanır.

İki uygulama da aynı endpoint'i kullanır: `https://fakestoreapi.com/products`. Tasarım bilerek benzer ve sade tutulmuştur: resim, ürün adı, fiyat; yüklenme, hata, boş durum ve yenileme.

## Gereksinimler

- Flutter SDK (`flutter --version`)
- Dart (Flutter ile birlikte gelir)
- Android emulator / fiziksel cihaz veya Chrome
- İnternet bağlantısı (API ve ürün görselleri için)

> Bu depoda **Flutter tarafından üretilen platform klasörleri** (`android/`, `ios/`, `web/` vb.) yer almaz. Kullanılan Flutter SDK sürümüne uygun platform dosyalarını oluşturmak için her uygulama dizininde `flutter create` çalıştırılır. Kaynak kodları ve `pubspec.yaml` hazırdır.

## Kurulum (Windows Git Bash / CMD / macOS / Linux)

```bash
git clone https://github.com/abdullahbelli/flutter-sustainable-architecture-demo.git
cd flutter-sustainable-architecture-demo
```

### A) Tek Widget sürümünü çalıştır

```bash
cd naive_version/product_app
flutter create --project-name product_app --platforms=android,web .
flutter pub get
flutter run
```

İlk uygulamayı çalıştırdıktan sonra katmanlı mimari sürümüne geçmeden önce terminalde ana proje dizinine geri dönün:
```bash
cd ../..
```
Bu komut, naive_version/product_app dizininden flutter-sustainable-architecture-demo ana dizinine dönmenizi sağlar.

### B) Katmanlı mimari sürümünü çalıştır

Yeni terminali repo kökünde aç veya ilk uygulama dizininden geri dön:

```bash
cd layered_version/product_app
flutter create --project-name product_app --platforms=android,web .
flutter pub get
flutter run
```

> Chrome için `flutter run -d chrome`, cihazları görmek için `flutter devices` komutunu kullanabilirsin. `flutter create` mevcut `lib/main.dart` dosyasını korumalıdır; komuttan sonra kontrol et.

## Testler

Katmanlı sürümde gerçek HTTP isteği olmadan **Fake Repository** kullanarak Controller ve Model testleri çalıştırılır:

```bash
cd layered_version/product_app
flutter test
flutter analyze
```

Testler: başarıyla yükleme, hata durumu, yüklenme bildirimleri, JSON fiyat dönüşümü.

## Mimari karşılaştırma

| Konu | Naive | Layered |
|---|---|---|
| HTTP | `ProductScreen` içinde | `ProductApiService` |
| JSON dönüşümü | `ProductScreen` içinde | `ApiProductRepository` ve `Product` |
| Veri erişimi | Doğrudan HTTP | `ProductRepository` sözleşmesi |
| Durum | `setState()` | `ProductController` + `ChangeNotifier` |
| Arayüz | `ProductScreen` | `ProductScreen` + `ListenableBuilder` |
| Test | HTTP ve UI'ya daha bağlı | Fake Repository ile Controller birim testi |

### Layered Version veri akışı

```text
ProductScreen --(loadProducts)--> ProductController
ProductController --(getProducts)--> ProductRepository (arayüz)
                                      ^
                                      |
                               ApiProductRepository
                                      |
                               ProductApiService
                                      |
                              Fake Store REST API

Dönüş: JSON -> Product listesi -> Controller -> notifyListeners -> View
```

`ProductRepository`, bir `abstract interface class` olup `ApiProductRepository` tarafından uygulanır. Bu **Dependency Inversion Principle**'a uygun bir bağımlılık yönüdür. `main.dart`'ta somut nesneler oluşturulup constructor'lar üzerinden verilir (**Dependency Injection**). Factory sınıfı eklenmedi; bu kadar küçük bir örnekte ek katman anlamlı bir fayda sağlamıyor. Observer yaklaşımı `ChangeNotifier`/`ListenableBuilder` ile gösterilir.

## Dosya yapısı

```text
flutter-sustainable-architecture-demo/
├── README.md
├── LICENSE
├── naive_version/
│   └── product_app/
│       ├── pubspec.yaml
│       └── lib/main.dart
└── layered_version/
    └── product_app/
        ├── pubspec.yaml
        ├── lib/
        │   ├── main.dart
        │   ├── models/product.dart
        │   ├── services/product_api_service.dart
        │   ├── repositories/product_repository.dart
        │   ├── repositories/api_product_repository.dart
        │   ├── controllers/product_controller.dart
        │   └── views/product_screen.dart
        └── test/
            ├── fakes/fake_product_repository.dart
            ├── product_controller_test.dart
            └── product_model_test.dart
```

## Bilinçli sadeleştirmeler

- Kimlik doğrulama, sayfalama, önbellek, offline storage ve özel DI paketleri eklenmedi.
- Hata mesajları kullanıcıya sade biçimde sunuluyor; üretim ortamında loglama ve ayrıntılı hata türleri gerekir.
- Aynı anda tekrar istek yapılması Controller tarafında önleniyor. Daha karmaşık navigasyon/süreçlerde request cancellation ve lifecycle stratejileri gerekir.
- Fake Store API haricî bir üçüncü taraf servistir; erişilebilirliği garanti değildir.
- Platform dosyaları yerelde `flutter create` ile üretilir.

## Medium Makalesi

Bu repository, Flutter'da Sürdürülebilir Mimari: Design Patterns, Repository Pattern ve Dependency Injection başlıklı Medium makalesini desteklemek amacıyla hazırlanmıştır.  Makalede Repository Pattern, Dependency Inversion Principle (DIP), Dependency Injection ve Flutter'da durum yönetimi gibi kavramlar ele alınmaktadır.
📖 **[Medium Makalesini Oku](https://medium.com/@belliabdullah/flutterda-s%C3%BCrd%C3%BCr%C3%BClebilir-mimari-design-patterns-repository-pattern-ve-dependency-injection-4b573113e617)**

## Lisans

MIT — ayrıntı için [LICENSE](LICENSE).
