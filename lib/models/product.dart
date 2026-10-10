/// Bir ürünün tip güvenli veri modeli. Fiyatlar kaynak API'deki gibi USD'dir.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.currency,
    required this.image,
    required this.category,
    required this.specs,
  });

  final int id;
  final String name;
  final String tagline;
  final String description;
  final double price;
  final String currency;
  final String image;
  final String category;
  final Map<String, String> specs;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: (json['id'] as num).toInt(),
    name: json['name'] as String,
    tagline: json['tagline'] as String,
    description: json['description'] as String,
    price: (json['price'] as num).toDouble(),
    currency: json['currency'] as String,
    image: json['image'] as String,
    category: json['category'] as String,
    specs: (json['specs'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, value.toString()),
    ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tagline': tagline,
    'description': description,
    'price': price,
    'currency': currency,
    'image': image,
    'category': category,
    'specs': specs,
  };
}
