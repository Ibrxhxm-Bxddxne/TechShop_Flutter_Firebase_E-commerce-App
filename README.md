# 🛒 TechShop - Application E-commerce Flutter & Firebase

TechShop est une application mobile moderne développée avec **Flutter** et **Firebase**. Elle offre une expérience d'achat fluide avec une gestion du catalogue en temps réel et un panier persistant lié au compte utilisateur.



---

## 🚀 Fonctionnalités principales

- **Authentification Sécurisée** : Inscription et connexion via Firebase Auth avec gestion des profils (Nom complet, Email).
- **Catalogue Dynamique** : Affichage des produits récupérés depuis Cloud Firestore avec gestion des nouveautés et des meilleures notes.
- **Filtres Intelligents** : Recherche par catégories dynamiques et filtrage par prix via un Slider réactif.
- **Panier Persistant** : Le panier est sauvegardé sur le Cloud ; retrouvez vos articles même après vous être déconnecté ou avoir changé d'appareil.
- **Détails Produits** : Page dédiée avec description complète, avis et gestion des quantités.
- **Synchronisation en Temps Réel** : Mise à jour instantanée du stock et des catégories sans rechargement de l'application.

---

## 🛠️ Stack Technique

- **Framework** : [Flutter](https://flutter.dev/) (Multi-plateforme iOS/Android)
- **Langage** : Dart
- **Backend** : [Firebase](https://firebase.google.com/)
    - **Authentication** : Gestion sécurisée des sessions.
    - **Cloud Firestore** : Base de données NoSQL pour les produits, utilisateurs et paniers.
- **Gestion d'état (State Management)** : [Provider](https://pub.dev/packages/provider) pour une réactivité globale.



---

## 📦 Structure du Projet

```text
lib/
 ├── models/          # Modèles de données (ex: product.dart)
 ├── providers/       # Logique métier et état global (ex: shop_provider.dart)
 ├── screens/         # Interfaces utilisateur (Home, Cart, Auth, etc.)
 ├── main.dart        # Configuration des routes et initialisation Firebase
assets/
 └── images/          # Assets locaux (logo, etc.)
