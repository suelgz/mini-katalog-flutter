import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/cart_model.dart';
import '../widgets/cart_button.dart';
import '../widgets/product_card.dart';
import 'catalog_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.products, required this.cart});
  final List<Product> products;
  final CartModel cart;

  void _catalog(BuildContext context, [String category = 'Tümü']) {
    // MaterialPageRoute ile geçiş; detay ekranı named route + arguments kullanır.
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => CatalogScreen(
          products: products,
          cart: cart,
          initialCategory: category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Row(
        children: [
          Icon(Icons.auto_awesome_rounded, color: Color(0xFF166956), size: 22),
          SizedBox(width: 9),
          Text(
            'mini.',
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900),
          ),
        ],
      ),
      actions: [
        CartButton(cart: cart),
        const SizedBox(width: 10),
      ],
    ),
    body: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TEKNOLOJİ, SENİNLE.',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 2,
                    color: Color(0xFF62706B),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Yeni favorini keşfet.',
                  style: TextStyle(
                    fontSize: 29,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Gününe eşlik edecek akıllı seçimler.',
                  style: TextStyle(color: Color(0xFF62706B)),
                ),
                const SizedBox(height: 22),
                InkWell(
                  key: const ValueKey('home-search'),
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _catalog(context),
                  child: const InputDecorator(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded),
                      hintText: 'Kataloğu keşfet',
                    ),
                    child: Text(
                      'Ürün veya kategori ara',
                      style: TextStyle(color: Color(0xFF62706B)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: AspectRatio(
                    aspectRatio: 4.46,
                    child: Image.asset(
                      'assets/images/banner.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, error, stack) => Container(
                        color: const Color(0xFFD5E8DE),
                        child: const Center(
                          child: Icon(
                            Icons.devices_rounded,
                            size: 72,
                            color: Color(0xFF166956),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kategoriler',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _catalog(context),
                      child: const Text('Tümünü gör'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _category(context, 'Telefon', Icons.phone_iphone_rounded),
                    _category(context, 'Bilgisayar', Icons.laptop_mac_rounded),
                    _category(context, 'Tablet', Icons.tablet_mac_rounded),
                    _category(context, 'Aksesuar', Icons.headphones_rounded),
                  ],
                ),
                const SizedBox(height: 24),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Öne çıkanlar',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'SENİN İÇİN',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.4,
                        color: Color(0xFF62706B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 260,
              mainAxisExtent: 250,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => ProductCard(
                product: products[index],
                onTap: () => Navigator.pushNamed(
                  context,
                  '/product',
                  arguments: products[index],
                ),
              ),
              childCount: products.length < 4 ? products.length : 4,
            ),
          ),
        ),
      ],
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: 0,
      onDestinationSelected: (index) {
        if (index == 1) _catalog(context);
        if (index == 2) Navigator.pushNamed(context, '/cart');
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Keşfet',
        ),
        NavigationDestination(
          key: ValueKey('nav-catalog'),
          icon: Icon(Icons.grid_view_rounded),
          label: 'Katalog',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_bag_outlined),
          label: 'Sepet',
        ),
      ],
    ),
  );

  Widget _category(BuildContext context, String label, IconData icon) =>
      Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _catalog(context, label),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5EEE8),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, color: const Color(0xFF166956)),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
