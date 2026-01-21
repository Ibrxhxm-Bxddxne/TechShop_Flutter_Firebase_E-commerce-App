import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class ShopProvider with ChangeNotifier {
  // Liste interne des produits dans le panier
  List<Product> _cartItems = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Getter pour accéder aux articles depuis les écrans
  List<Product> get cartItems => _cartItems;

  // Calcul du prix total dynamique
  double get totalCartPrice {
    return _cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  // --- MÉTHODES DE MANIPULATION DU PANIER ---

  // Ajouter un produit ou augmenter sa quantité
  void addToCart(Product product) {
    int index = _cartItems.indexWhere((item) => item.id == product.id);

    if (index >= 0) {
      _cartItems[index].quantity += 1;
    } else {
      // On s'assure que la quantité est à 1 lors du premier ajout
      product.quantity = 1;
      _cartItems.add(product);
    }

    notifyListeners(); // Met à jour l'UI (badges, liste panier)
    _syncWithFirebase(); // Sauvegarde dans le document 'carts'
  }

  // Supprimer totalement un produit du panier
  void removeFromCart(Product product) {
    _cartItems.removeWhere((item) => item.id == product.id);
    notifyListeners();
    _syncWithFirebase();
  }

  // Vider le panier (utile après une commande ou déconnexion)
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
    _syncWithFirebase();
  }

  // Déconnexion propre : vide le panier local sans supprimer les données sur Firebase
  void signOutAndClearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // --- SYNCHRONISATION AVEC FIREBASE ---

  // Crée ou met à jour le document dans la collection 'carts'
  Future<void> _syncWithFirebase() async {
    final User? user = _auth.currentUser;

    // On ne synchronise que si l'utilisateur est connecté
    if (user != null) {
      final cartData = _cartItems
          .map(
            (item) => {
              'id': item.id,
              'name': item.name,
              'price': item.price,
              'image': item.image,
              'quantity': item.quantity,
              'type': item.type,
            },
          )
          .toList();

      try {
        await _firestore.collection('carts').doc(user.uid).set({
          'items': cartData,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print("Erreur lors de la synchronisation : $e");
      }
    }
  }

  // Charger le panier depuis Firestore (à appeler lors de la connexion)
  Future<void> loadCartFromFirebase() async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    try {
      DocumentSnapshot doc = await _firestore
          .collection('carts')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        final List<dynamic> items = data['items'] ?? [];

        _cartItems = items
            .map(
              (item) => Product(
                id: item['id'],
                name: item['name'],
                price: (item['price'] as num).toDouble(),
                image: item['image'],
                quantity: item['quantity'] ?? 1,
                type: item['type'] ?? '',
                description: '', // Non nécessaire pour l'affichage du panier
                rating: 0,
                reviewCount: 0,
                createdAt: DateTime.now(),
              ),
            )
            .toList();

        notifyListeners();
      }
    } catch (e) {
      print("Erreur lors du chargement du panier : $e");
    }
  }
}
