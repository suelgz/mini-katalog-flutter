import 'package:flutter/material.dart';

import 'data/product_repository.dart';
import 'models/product.dart';
import 'screens/home_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'state/cart_model.dart';

void main() => runApp(const MiniCatalogApp());

class MiniCatalogApp extends StatefulWidget {
  const MiniCatalogApp({super.key});
  @override
  State<MiniCatalogApp> createState() => _MiniCatalogAppState();
}

class _MiniCatalogAppState extends State<MiniCatalogApp> {
  final _cart = CartModel();
  late Future<List<Product>> _products;
  @override
  void initState() {
    super.initState();
    _products = ProductRepository().loadProducts();
  }

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Mini Katalog',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF166956),
        primary: const Color(0xFF166956),
        surface: const Color(0xFFF5F6F2),
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F6F2),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF5F6F2),
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          color: Color(0xFF162B24),
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: Color(0xFFD5E8DE),
      ),
    ),
    home: FutureBuilder<List<Product>>(
      future: _products,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  const Text('Ürünler yüklenemedi.'),
                  TextButton(
                    onPressed: () => setState(
                      () => _products = ProductRepository().loadProducts(),
                    ),
                    child: const Text('Tekrar dene'),
                  ),
                ],
              ),
            ),
          );
        if (!snapshot.hasData)
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        return HomeScreen(products: snapshot.data!, cart: _cart);
      },
    ),
    onGenerateRoute: (settings) {
      if (settings.name == '/cart')
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => CartScreen(cart: _cart),
        );
      if (settings.name == '/product' && settings.arguments is Product) {
        final product = settings.arguments! as Product;
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => ProductDetailScreen(product: product, cart: _cart),
        );
      }
      if (settings.name == '/catalog')
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => FutureBuilder<List<Product>>(
            future: _products,
            builder: (context, snapshot) => snapshot.hasData
                ? CatalogScreen(products: snapshot.data!, cart: _cart)
                : const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
          ),
        );
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Sayfa bulunamadı')),
          body: Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Geri dön'),
            ),
          ),
        ),
      );
    },
  );
}
