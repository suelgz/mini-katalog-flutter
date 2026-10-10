import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/main.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/state/cart_model.dart';
import 'package:mini_katalog/utils/format.dart';

Future<void> capture(WidgetTester tester, String name) async {
  if (Platform.environment['RUN_SCREENSHOTS'] != 'true') return;
  await tester.pumpAndSettle();
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const ValueKey('capture')),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    await Directory('screenshots').create(recursive: true);
    await File(
      'screenshots/$name.png',
    ).writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final rows =
      jsonDecode(File('assets/data/products.json').readAsStringSync())
          as List<dynamic>;
  final products = rows
      .map((row) => Product.fromJson(row as Map<String, dynamic>))
      .toList();

  test('Tüm ürünler JSON dönüşümünde korunur; görseller mevcut', () {
    expect(products, hasLength(20));
    expect(products.map((p) => p.id).toSet(), hasLength(20));
    for (final p in products) {
      expect(Product.fromJson(p.toJson()).toJson(), p.toJson());
      expect(File(p.image).existsSync(), isTrue);
      expect(p.price, greaterThan(0));
      expect(p.currency, 'USD');
    }
  });

  test('Sepet: adet, toplam, azaltma, kaldırma ve temizleme', () {
    final cart = CartModel();
    addTearDown(cart.dispose);
    cart.add(products[0]);
    cart.add(products[0]);
    cart.add(products[1]);
    expect(cart.totalQuantity, 3);
    expect(cart.items, hasLength(2));
    expect(cart.totalPrice, products[0].price * 2 + products[1].price);
    cart.decrease(products[0].id);
    expect(cart.totalQuantity, 2);
    cart.decrease(products[0].id);
    expect(cart.items, hasLength(1));
    cart.remove(products[1].id);
    expect(cart.totalPrice, 0);
    cart.decrease(-1);
    cart.add(products[0]);
    cart.clear();
    expect(cart.items, isEmpty);
  });

  test('Türkçe arama ve USD biçimi', () {
    expect(normalize('BİLGİSAYAR'), normalize('bilgisayar'));
    expect(normalize('İPHONE'), normalize('iphone'));
    expect(money(2499), '\$2.499,00');
  });

  testWidgets('Ana sayfa → katalog → detay → sepet; arama ve geri dönüş', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final sdk = Platform.environment['FLUTTER_ROOT'];
    await tester.runAsync(() async {
      if (sdk != null) {
        final fonts = '$sdk/bin/cache/artifacts/material_fonts';
        final loader = FontLoader('Roboto');
        for (final file in [
          'Roboto-Regular.ttf',
          'Roboto-Medium.ttf',
          'Roboto-Bold.ttf',
          'Roboto-Black.ttf',
        ]) {
          loader.addFont(
            Future.value(
              ByteData.sublistView(File('$fonts/$file').readAsBytesSync()),
            ),
          );
        }
        await loader.load();
        final icons = FontLoader('MaterialIcons')
          ..addFont(
            Future.value(
              ByteData.sublistView(
                File('$fonts/MaterialIcons-Regular.otf').readAsBytesSync(),
              ),
            ),
          );
        await icons.load();
      }
    });
    await tester.pumpWidget(
      const RepaintBoundary(key: ValueKey('capture'), child: MiniCatalogApp()),
    );
    await tester.runAsync(() async {
      final context = tester.element(find.byType(MaterialApp));
      await Future.wait([
        precacheImage(const AssetImage('assets/images/banner.png'), context),
        ...products.map((p) => precacheImage(AssetImage(p.image), context)),
      ]);
    });
    await tester.pumpAndSettle();
    expect(find.text('Yeni favorini keşfet.'), findsOneWidget);
    await capture(tester, '01_ana_sayfa');
    await tester.tap(find.byKey(const ValueKey('nav-catalog')));
    await tester.pumpAndSettle();
    expect(find.text('20 ürün'), findsOneWidget);
    await capture(tester, '02_urun_katalogu');
    await tester.tap(find.byKey(const ValueKey('product-1')));
    await tester.pumpAndSettle();
    expect(find.text('Ürün detayı'), findsOneWidget);
    expect(find.text('iPhone 15 Pro'), findsOneWidget);
    await capture(tester, '03_urun_detayi');
    await tester.tap(find.byKey(const ValueKey('add-to-cart')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('open-cart')).last);
    await tester.pumpAndSettle();
    expect(find.text('Sepetim (1)'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('increase-1')));
    await tester.pumpAndSettle();
    expect(find.text('Sepetim (2)'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('cart-total'))).data,
      '\$1.998,00',
    );
    await capture(tester, '04_sepet');
    await tester.tap(find.byKey(const ValueKey('decrease-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('decrease-1')));
    await tester.pumpAndSettle();
    expect(find.text('Sepetin henüz boş'), findsOneWidget);
    await capture(tester, '05_bos_sepet');
    await tester.tap(find.byTooltip('Back').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('search')), 'macbook');
    await tester.pumpAndSettle();
    expect(find.text('4 ürün'), findsOneWidget);
    await capture(tester, '06_arama');
    await tester.enterText(find.byKey(const ValueKey('search')), 'zzzz');
    await tester.pumpAndSettle();
    expect(find.text('Ürün bulunamadı'), findsOneWidget);
    await tester.tap(find.text('Filtreleri temizle'));
    await tester.pumpAndSettle();
    expect(find.text('20 ürün'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
