import 'package:flutter/material.dart';

class CartItem {
  final int cameraId;
  final int quantity;

  CartItem({required this.cameraId, required this.quantity});
}

class BookingCartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addItem(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeItem(int cameraId) {
    _cartItems.removeWhere((item) => item.cameraId == cameraId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
