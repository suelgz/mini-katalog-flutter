import 'package:flutter/material.dart';

import '../models/product.dart';
import '../utils/format.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap});
  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: Color(0xFFE4E8E5)),
    ),
    child: InkWell(
      key: ValueKey('product-${product.id}'),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Hero(
                  tag: 'product-${product.id}',
                  child: Image.asset(
                    product.image,
                    fit: BoxFit.contain,
                    errorBuilder: (_, error, stack) => const Icon(
                      Icons.image_not_supported_outlined,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              product.category.toUpperCase(),
              style: const TextStyle(
                fontSize: 9,
                letterSpacing: 1.3,
                color: Color(0xFF62706B),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                Expanded(
                  child: Text(
                    money(product.price),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_outward_rounded,
                  size: 18,
                  color: Color(0xFF166956),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
