# Flutter Günlük Eğitim – Proje Çıktısı Raporu

**Proje:** Mini Katalog Uygulaması  
**Hazırlayan:** Su Elagöz  
**Teknoloji:** Flutter / Dart  
**Kapsam:** Beş günlük temel Flutter eğitimi

## Amaç ve sonuç

Widget yapısı, sayfa geçişleri, veri modeli, asset yönetimi ve basit state güncellemesi kullanılarak bir teknoloji ürün kataloğu hazırlanmıştır. Uygulama ana sayfa, katalog, ürün detayı ve sepet ekranlarından oluşur. Ürünler yerel JSON simülasyonundan yüklenir; harici Flutter paketi kullanılmaz.

## Günlere göre uygulama karşılıkları

| Gün | Öğrenme hedefi | Projedeki karşılığı |
| --- | --- | --- |
| 1 | Flutter yapısı, Stateless/Stateful | `MiniCatalogApp`, `HomeScreen`, `CatalogScreen` |
| 2 | Dart türleri, koleksiyonlar, UI | `Product`, `List<Product>`, `Map<int, CartItem>`, Row/Column/Card/Expanded |
| 3 | Navigator ve veri aktarımı | Ana sayfadan `MaterialPageRoute`; detay için named route ve `arguments` |
| 4 | JSON, listeleme, asset ve filtre | `ProductRepository`, `fromJson/toJson`, `ListView.separated`, `Image.asset`, arama/kategori |
| 5 | Grid, detay, sepet ve tema | `GridView.builder`, `ProductDetailScreen`, `CartModel`, Material 3 tema |

## Veri ve state akışı

1. `ProductRepository`, `assets/data/products.json` dosyasını `rootBundle` üzerinden okur.
2. `jsonDecode` sonucu `Product.fromJson` ile tip güvenli nesnelere dönüştürülür.
3. Ana sayfa ve katalog aynı ürün listesini kullanır. Filtreler yerel liste üzerinde uygulanır.
4. Kart seçilince `/product` rotasına seçilen ürün nesnesi gönderilir.
5. Sepete ekleme `CartModel.add` metodunu çalıştırır; `notifyListeners` ile sepet ve rozet güncellenir.
6. Sepet toplamı her ürünün fiyatı × adedinin toplamıdır. Adet 1 iken azaltma ürünü kaldırır.
7. Geri düğmesi Navigator üzerinden önceki sayfaya döner; katalog filtreleri önceki sayfanın state'inde korunur.

## Veri kaynakları ve sınırlar

WANTAPI'nin eğitim amaçlı ürün verileri ve banner/görselleri kullanılmıştır. Kaynak yanıtı ayrıca saklanmıştır. Uygulamada 20 ürün vardır; fiyatların para birimi USD'dir. Ürün açıklamaları kaynağın İngilizce metinleridir. Sepet kalıcı değildir; ödeme ve sipariş işlemi simülasyondur.

## Doğrulama ve teslim

Testlerin ve analiz işleminin gerçek sonuçları `VALIDATION.md` içinde yer alır. Arayüz görüntüleri `screenshots/` klasöründedir; bunlar Flutter widget testi üzerinden üretilmiştir. Çalıştırma adımları, Flutter sürümü, ekran görüntüleri ve kaynak açıklaması `README.md` içinde bulunur.

Public GitHub repository: https://github.com/suelgz/mini-katalog-flutter. Teslim formuna bu link eklenmelidir.
