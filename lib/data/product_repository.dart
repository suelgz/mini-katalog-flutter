import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

class ProductRepository {
  Future<List<Product>> loadProducts() async {
    // Ağ isteği yerine JSON simülasyonu: internet olmadan da çalışır.
    final source = await rootBundle.loadString('assets/data/products.json');
    final rows = jsonDecode(source) as List<dynamic>;
    return rows
        .map((row) => Product.fromJson(row as Map<String, dynamic>))
        .toList();
  }
}
