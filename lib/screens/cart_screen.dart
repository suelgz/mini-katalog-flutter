import 'package:flutter/material.dart';

import '../state/cart_model.dart';
import '../utils/format.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, required this.cart});
  final CartModel cart;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: cart,
    builder: (context, child) => Scaffold(
      appBar: AppBar(
        title: Text('Sepetim (${cart.totalQuantity})'),
        actions: [
          if (cart.items.isNotEmpty)
            IconButton(
              tooltip: 'Sepeti temizle',
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Sepet temizlensin mi?'),
                    content: const Text('Sepetteki tüm ürünler çıkarılacak.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Vazgeç'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Temizle'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) cart.clear();
              },
            ),
          const SizedBox(width: 10),
        ],
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE5EEE8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 48,
                        color: Color(0xFF166956),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Sepetin henüz boş',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Katalogdan favorilerini ekleyerek başla.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 22),
                    FilledButton(
                      onPressed: () => Navigator.pushNamed(context, '/catalog'),
                      child: const Text('Ürünleri keşfet'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              itemCount: cart.items.length,
              separatorBuilder: (_, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 72,
                          height: 100,
                          child: Image.asset(
                            item.product.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Ürünü kaldır',
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(Icons.close, size: 18),
                                    onPressed: () =>
                                        cart.remove(item.product.id),
                                  ),
                                ],
                              ),
                              Text(
                                money(item.subtotal),
                                style: const TextStyle(
                                  color: Color(0xFF166956),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  IconButton(
                                    key: ValueKey(
                                      'decrease-${item.product.id}',
                                    ),
                                    tooltip: 'Adedi azalt',
                                    onPressed: () =>
                                        cart.decrease(item.product.id),
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  IconButton(
                                    key: ValueKey(
                                      'increase-${item.product.id}',
                                    ),
                                    tooltip: 'Adedi artır',
                                    onPressed: () => cart.add(item.product),
                                    icon: const Icon(Icons.add_circle_outline),
                                  ),
                                  const Spacer(),
                                  const Text(
                                    'USD',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF62706B),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              top: false,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ara toplam'),
                        Text(money(cart.totalPrice)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Toplam',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          money(cart.totalPrice),
                          key: const ValueKey('cart-total'),
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Demo tamamlandı'),
                            content: const Text(
                              'Bu bir eğitim uygulamasıdır. Gerçek sipariş oluşturulmaz ve ödeme alınmaz.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Tamam'),
                              ),
                            ],
                          ),
                        ),
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Alışverişi tamamla (demo)'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Ödeme alınmaz • Sepet yalnızca bu oturumda saklanır',
                      style: TextStyle(fontSize: 11, color: Color(0xFF62706B)),
                    ),
                  ],
                ),
              ),
            ),
    ),
  );
}
