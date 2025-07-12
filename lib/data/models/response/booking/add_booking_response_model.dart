import 'dart:convert';

class AddBookingResponseModel {
    final String? message;
    final int? statusCode;
    final Data? data;

    AddBookingResponseModel({
        this.message,
        this.statusCode,
        this.data,
    });

    factory AddBookingResponseModel.fromJson(String str) => AddBookingResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AddBookingResponseModel.fromMap(Map<String, dynamic> json) => AddBookingResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "status_code": statusCode,
        "data": data?.toMap(),
    };
}

class Data {
    final int? userId;
    final DateTime? startDate;
    final DateTime? endDate;
    final int? totalPrice;
    final String? status;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? id;
    final List<Camera>? cameras;

    Data({
        this.userId,
        this.startDate,
        this.endDate,
        this.totalPrice,
        this.status,
        this.updatedAt,
        this.createdAt,
        this.id,
        this.cameras,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
        endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        totalPrice: json["total_price"],
        status: json["status"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
        cameras: json["cameras"] == null ? [] : List<Camera>.from(json["cameras"]!.map((x) => Camera.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "user_id": userId,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "total_price": totalPrice,
        "status": status,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "cameras": cameras == null ? [] : List<dynamic>.from(cameras!.map((x) => x.toMap())),
    };
}

class Camera {
    final int? id;
    final String? name;
    final String? brand;
    final String? description;
    final String? rentalPricePerDay;
    final String? status;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic fotoCamera;
    final Pivot? pivot;

    Camera({
        this.id,
        this.name,
        this.brand,
        this.description,
        this.rentalPricePerDay,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.fotoCamera,
        this.pivot,
    });

    factory Camera.fromJson(String str) => Camera.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Camera.fromMap(Map<String, dynamic> json) => Camera(
        id: json["id"],
        name: json["name"],
        brand: json["brand"],
        description: json["description"],
        rentalPricePerDay: json["rental_price_per_day"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        fotoCamera: json["foto_camera"],
        pivot: json["pivot"] == null ? null : Pivot.fromMap(json["pivot"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "brand": brand,
        "description": description,
        "rental_price_per_day": rentalPricePerDay,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "foto_camera": fotoCamera,
        "pivot": pivot?.toMap(),
    };
}

class Pivot {
    final int? bookingId;
    final int? cameraId;
    final int? quantity;
    final String? priceAtBooking;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Pivot({
        this.bookingId,
        this.cameraId,
        this.quantity,
        this.priceAtBooking,
        this.createdAt,
        this.updatedAt,
    });

    factory Pivot.fromJson(String str) => Pivot.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Pivot.fromMap(Map<String, dynamic> json) => Pivot(
        bookingId: json["booking_id"],
        cameraId: json["camera_id"],
        quantity: json["quantity"],
        priceAtBooking: json["price_at_booking"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "booking_id": bookingId,
        "camera_id": cameraId,
        "quantity": quantity,
        "price_at_booking": priceAtBooking,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
