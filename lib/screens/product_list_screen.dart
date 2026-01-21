import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _selectedType = 'Tous';
  double _maxPrice = 2000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nos Produits")),
      body: Column(
        children: [
          _buildDynamicFilterPanel(), // Appel de la nouvelle version dynamique
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _buildQuery(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Center(child: Text("Erreur : ${snapshot.error}"));
                if (snapshot.connectionState == ConnectionState.waiting)
                  return const Center(child: CircularProgressIndicator());
                if (snapshot.data!.docs.isEmpty)
                  return const Center(child: Text("Aucun produit trouvé."));

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, i) {
                    Product product = Product.fromFirestore(
                      snapshot.data!.docs[i],
                    );
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: ListTile(
                        leading: Image.network(
                          product.image,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(product.name),
                        subtitle: Text("${product.price} € - ${product.type}"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: product,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Requête filtrée
  Stream<QuerySnapshot> _buildQuery() {
    Query query = FirebaseFirestore.instance
        .collection('products')
        .where('price', isLessThanOrEqualTo: _maxPrice);

    if (_selectedType != 'Tous') {
      query = query.where('type', isEqualTo: _selectedType);
    }

    return query.snapshots();
  }

  // Panel de filtres avec catégories dynamiques
  Widget _buildDynamicFilterPanel() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          // StreamBuilder pour récupérer les types uniques
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('products')
                .snapshots(),
            builder: (context, snapshot) {
              List<String> categories = ['Tous']; // Valeur par défaut

              if (snapshot.hasData) {
                // On extrait tous les "type", on enlève les doublons avec toSet()
                final types = snapshot.data!.docs
                    .map((doc) => doc['type'] as String)
                    .toSet()
                    .toList();
                categories.addAll(types);
              }

              // Sécurité : si le type sélectionné n'est plus dans la liste (ex: produit supprimé)
              if (!categories.contains(_selectedType)) {
                _selectedType = 'Tous';
              }

              return DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: "Catégorie (Dynamique)",
                ),
                items: categories
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedType = val!),
              );
            },
          ),
          Slider(
            value: _maxPrice,
            min: 0,
            max: 2000,
            divisions: 20,
            label: "Prix max : ${_maxPrice.round()}€",
            onChanged: (val) => setState(() => _maxPrice = val),
          ),
        ],
      ),
    );
  }
}
