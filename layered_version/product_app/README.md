# Layered Product App

Bu dizin tek başına bir Flutter uygulamasıdır. Kök dizindeki README.md dosyasında kurulum adımları bulunur.

```bash
flutter create --project-name product_app --platforms=android,web .
flutter pub get
flutter run
```

> Flutter platform dosyaları (`android/`, `web/` vb.) bilinçli olarak repoya eklenmedi; kullandığınız Flutter SDK ile `flutter create` komutu üretir. Mevcut `lib/` dosyaları korunmalıdır.
