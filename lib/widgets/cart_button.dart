import 'package:flutter/material.dart';

import '../state/cart_model.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key, required this.cart});
  final CartModel cart;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: cart,
    builder: (context, child) => IconButton(
      key: const ValueKey('open-cart'),
      tooltip: 'Sepetim',
      onPressed: () => Navigator.pushNamed(context, '/cart'),
      icon: Badge(
        isLabelVisible: cart.totalQuantity > 0,
        label: Text('${cart.totalQuantity}'),
        child: const Icon(Icons.shopping_bag_outlined),
      ),
    ),
  );
}
