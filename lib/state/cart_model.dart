import 'package:flutter/foundation.dart';

import '../models/product.dart';

class CartItem {
  const CartItem({required this.product, required this.quantity});
  final Product product;
  final int quantity;
  double get subtotal => product.price * quantity;
}

/// Sepet bellekte tutulur. Uygulama kapanınca sıfırlanır.
class CartModel extends ChangeNotifier {
  final Map<int, CartItem> _items = {};
  List<CartItem> get items => List.unmodifiable(_items.values);
  int get totalQuantity =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice =>
      _items.values.fold(0, (sum, item) => sum + item.subtotal);

  void add(Product product) {
    _items[product.id] = CartItem(
      product: product,
      quantity: (_items[product.id]?.quantity ?? 0) + 1,
    );
    notifyListeners();
  }

  void decrease(int id) {
    final current = _items[id];
    if (current == null) return;
    if (current.quantity == 1) {
      _items.remove(id);
    } else {
      _items[id] = CartItem(
        product: current.product,
        quantity: current.quantity - 1,
      );
    }
    notifyListeners();
  }

  void remove(int id) {
    if (_items.remove(id) != null) notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
