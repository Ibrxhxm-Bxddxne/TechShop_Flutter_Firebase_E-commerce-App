import 'package:cloud_firestore/cloud_firestore.dart'; // <--- IMPORTATION CORRIGÉE

class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String image;
  final String type;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  int quantity; // <--- Ajoutez ceci (pas final car elle peut changer)

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.type,
    required this.rating,
    required this.reviewCount,
    required this.createdAt,
    this.quantity = 1, // <--- Par défaut à 1
  });

  // Mettez à jour le factory fromFirestore
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      type: data['type'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      quantity: 1, // Initialisé à 1 lors du chargement
    );
  }
}
