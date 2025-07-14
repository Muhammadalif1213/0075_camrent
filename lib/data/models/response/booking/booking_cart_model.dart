// models/booking_cart_model.dart
import 'package:flutter/material.dart';
import 'package:paml_camrent/data/models/response/product/get_all_product__response_model.dart';

class BookingItem {
  final Datum camera;
  int quantity;

  BookingItem({required this.camera, this.quantity = 1});
}

class BookingCartProvider with ChangeNotifier {
  final List<BookingItem> _items = [];

  List<BookingItem> get items => _items;

  void addCamera(Datum camera) {
    final index = _items.indexWhere((item) => item.camera.id == camera.id);
    if (index == -1) {
      _items.add(BookingItem(camera: camera));
    } else {
      _items[index].quantity++;
    }
    notifyListeners();
  }

  void removeCamera(int cameraId) {
    _items.removeWhere((item) => item.camera.id == cameraId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}