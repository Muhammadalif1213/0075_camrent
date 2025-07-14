// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

// Model utama untuk menampung keseluruhan response
class AdminBookingResponseModel {
  final List<Booking> data;
  AdminBookingResponseModel({required this.data});

  factory AdminBookingResponseModel.fromMap(Map<String, dynamic> json) =>
      AdminBookingResponseModel(
        data: List<Booking>.from(json["data"].map((x) => Booking.fromMap(x))),
      );
}

// Model untuk satu data booking
class Booking {
  final int id;
  final int userId;
  final String startDate;
  final String endDate;
  final String totalPrice;
  final String status;
  final User user;
  final List<Camera> cameras;
  final String? location;
  final File? idCardImagePath;
  final String paymentStatus;

  Booking({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.user,
    required this.cameras,
    this.location,
    this.idCardImagePath,
    required this.paymentStatus,
  });

  factory Booking.fromMap(Map<String, dynamic> json) => Booking(
    id: json["id"],
    userId: json["user_id"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    totalPrice: json["total_price"],
    status: json["status"],
    user: User.fromMap(json["user"]),
    cameras: List<Camera>.from(json["cameras"].map((x) => Camera.fromMap(x))),
    location: json["location"],
    idCardImagePath: json["id_card_image_path"] == null
        ? null
        : File(json["id_card_image_path"]),
    paymentStatus: json["payment_status"] ?? 'unpaid',
  );
}

// Model untuk data user di dalam booking
class User {
  final int id;
  final String name;
  final String email;
  User({required this.id, required this.name, required this.email});
  factory User.fromMap(Map<String, dynamic> json) =>
      User(id: json["id"], name: json["name"], email: json["email"]);
}

// Model untuk data kamera di dalam booking
class Camera {
  final int id;
  final String name;
  final String brand;
  Camera({required this.id, required this.name, required this.brand});
  factory Camera.fromMap(Map<String, dynamic> json) =>
      Camera(id: json["id"], name: json["name"], brand: json["brand"]);
}
