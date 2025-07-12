
import 'dart:convert';
import 'dart:io';

class AddBookingRequestModel {
    final String startDate;
    final String endDate;
    final List<CartItem> items;

    AddBookingRequestModel({
        required this.startDate,
        required this.endDate,
        required this.items,
    });

    Map<String, dynamic> toMap() {
        return {
            'start_date': startDate,
            'end_date': endDate,
            'items': items.map((x) => x.toMap()).toList(),
        };
    }

    String toJson() => json.encode(toMap());
}

class CartItem {
    final int cameraId;
    final int quantity;

    CartItem({
        required this.cameraId,
        required this.quantity,
    });

    Map<String, dynamic> toMap() {
        return {
            'camera_id': cameraId,
            'quantity': quantity,
        };
    }
}