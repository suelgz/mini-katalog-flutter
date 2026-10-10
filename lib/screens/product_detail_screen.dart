import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/cart_model.dart';
import '../utils/format.dart';
import '../widgets/cart_button.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.cart,
  });
  final Product product;
  final CartModel cart;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Ürün detayı'),
      actions: [
        CartButton(cart: cart),
        const SizedBox(width: 10),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
      children: [
        Container(
          height: 280,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Hero(
            tag: 'product-${product.id}',
            child: Image.asset(product.image, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          product.category.toUpperCase(),
          style: const TextStyle(
            letterSpacing: 1.5,
            fontSize: 11,
            color: Color(0xFF166956),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          product.tagline,
          style: const TextStyle(color: Color(0xFF62706B), fontSize: 15),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: product.specs.entries
              .map(
                (entry) => Chip(
                  label: Text(entry.value),
                  avatar: const Icon(Icons.check_circle_outline, size: 17),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 20),
        const Text(
          'Ürün hakkında',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          product.description,
          style: const TextStyle(height: 1.65, color: Color(0xFF62706B)),
        ),
        const SizedBox(height: 18),
        const Text(
          'Eğitim amaçlı örnek ürün • Fiyatlar USD',
          style: TextStyle(fontSize: 12, color: Color(0xFF62706B)),
        ),
      ],
    ),
    bottomNavigationBar: SafeArea(
      top: false,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BİRİM FİYAT',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1,
                      color: Color(0xFF62706B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    money(product.price),
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              key: const ValueKey('add-to-cart'),
              onPressed: () {
                cart.add(product);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text('${product.name} sepete eklendi'),
                      action: SnackBarAction(
                        label: 'Sepeti aç',
                        onPressed: () => Navigator.pushNamed(context, '/cart'),
                      ),
                    ),
                  );
              },
              icon: const Icon(Icons.add_shopping_cart_rounded, size: 20),
              label: const Text('Sepete ekle'),
            ),
          ],
        ),
      ),
    ),
  );
}
