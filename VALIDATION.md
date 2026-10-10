# Doğrulama kaydı

## Ortam

- Flutter: **3.47.7**, stable
- Dart: **3.13.5**
- Flutter framework revision: `abaf9c5237`
- Linux x64 geliştirme/test ortamı

## Tamamlanan kontroller

| Kontrol | Sonuç |
| --- | --- |
| `dart format --output=none --set-exit-if-changed lib test` | 12 dosya; 0 biçim değişikliği |
| `flutter analyze --no-pub` | No issues found |
| `flutter test --no-pub test/catalog_test.dart` | 4 test başarılı |
| `flutter build web --no-pub --no-web-resources-cdn` | `build/web` başarıyla üretildi |
| Flutter widget görüntüleri | 6 PNG, 780 × 1688 piksel |
| ZIP içerik kontrolü | README, kodlar, JSON, görseller, Android/web yapılandırması, testler ve 6 ekran görüntüsü |

## Testlerin kapsadığı davranışlar

1. Yirmi ürünün benzersiz kimlikleri, `fromJson/toJson` dönüşümü, pozitif fiyatları, USD para birimi ve yerel görsellerin varlığı.
2. Aynı ürünü tekrar ekleme, toplam fiyat, toplam adet, adedi azaltınca son ürünün çıkarılması, ürün kaldırma ve sepet temizleme.
3. Türkçe karakterlerin aramada normalizasyonu ve fiyat biçimlendirme.
4. Ana sayfadan kataloğa geçiş; 20 ürünün listelenmesi; seçilen ürünün detay ekranına aktarılması; sepete ekleme; adedi artırma ve toplamın güncellenmesi; boş sepet; önceki ekranlara dönüş; arama ve sonuç bulunamadığında filtrelerin sıfırlanması.

Ekranlar gerçek Flutter widget ağacından alınmıştır. Görsel doğrulamada ikonlar, fontlar, ürün görselleri, kategori satırı, detay ekranı ve sepet toplamı incelenmiştir.

## Çalıştırılmayan işlemler

Android SDK/emülatör bu ortamda bulunmadığından Android APK derlemesi ve fiziksel cihaz testi yapılmamıştır. Android klasörü resmi `flutter create` ile oluşturulmuştur; APK üretme adımları README'dedir. Web derlemesi uygulama kodunun derlenebildiğini doğrular; tarayıcıda ayrı uçtan uca çalışma testi yapılmamıştır.

Web derlemesinde Flutter SDK'nin iç Cupertino ikon referansıyla ilgili engelleyici olmayan bir font uyarısı görüldü; derleme başarılıdır. Uygulama Material ikonlarını kullanır; eğitim şartına uymak için ek `cupertino_icons` paketi eklenmemiştir.

Public GitHub repository: https://github.com/suelgz/mini-katalog-flutter. Kaynak kodu ve ekran görüntüleri bu depoda teslim edilir. Derleme çıktıları ve yerel SDK depoya eklenmez.
