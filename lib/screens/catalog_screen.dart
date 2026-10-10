import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/cart_model.dart';
import '../utils/format.dart';
import '../widgets/product_card.dart';
import '../widgets/cart_button.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({
    super.key,
    required this.products,
    required this.cart,
    this.initialCategory = 'Tümü',
  });
  final List<Product> products;
  final CartModel cart;
  final String initialCategory;
  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _search = TextEditingController();
  late String _category;
  String _sort = 'recommended';
  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = normalize(_search.text.trim());
    final visible = widget.products
        .where(
          (p) =>
              (_category == 'Tümü' || p.category == _category) &&
              normalize('${p.name} ${p.category}').contains(query),
        )
        .toList();
    if (_sort == 'low') visible.sort((a, b) => a.price.compareTo(b.price));
    if (_sort == 'high') visible.sort((a, b) => b.price.compareTo(a.price));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün kataloğu'),
        actions: [
          CartButton(cart: widget.cart),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: TextField(
              key: const ValueKey('search'),
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Ürün veya kategori ara',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Aramayı temizle',
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(_search.clear),
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 66,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: ['Tümü', 'Telefon', 'Bilgisayar', 'Tablet', 'Aksesuar']
                  .map(
                    (category) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: _category == category,
                        showCheckmark: false,
                        onSelected: (_) => setState(() => _category = category),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 14, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${visible.length} ürün',
                    style: const TextStyle(color: Color(0xFF62706B)),
                  ),
                ),
                PopupMenuButton<String>(
                  tooltip: 'Sırala',
                  onSelected: (value) => setState(() => _sort = value),
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'recommended',
                      child: Text('Önerilen'),
                    ),
                    PopupMenuItem(
                      value: 'low',
                      child: Text('Fiyat: düşükten yükseğe'),
                    ),
                    PopupMenuItem(
                      value: 'high',
                      child: Text('Fiyat: yüksekten düşüğe'),
                    ),
                  ],
                  child: const Row(
                    children: [
                      Text('Sırala'),
                      SizedBox(width: 5),
                      Icon(Icons.sort_rounded, size: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: visible.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 48,
                            color: Color(0xFF62706B),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Ürün bulunamadı',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('Başka bir kelime veya kategori dene.'),
                          TextButton(
                            onPressed: () => setState(() {
                              _search.clear();
                              _category = 'Tümü';
                            }),
                            child: const Text('Filtreleri temizle'),
                          ),
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
                    key: const ValueKey('catalog-grid'),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 260,
                          mainAxisExtent: 250,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: visible.length,
                    itemBuilder: (context, index) => ProductCard(
                      product: visible[index],
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/product',
                        arguments: visible[index],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
