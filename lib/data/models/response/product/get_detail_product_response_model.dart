import 'dart:convert';

class GetDetailProductResponseModel {
    final String? message;
    final Data? data;

    GetDetailProductResponseModel({
        this.message,
        this.data,
    });

    factory GetDetailProductResponseModel.fromJson(String str) => GetDetailProductResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory GetDetailProductResponseModel.fromMap(Map<String, dynamic> json) => GetDetailProductResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
    };
}

class Data {
    final int? id;
    final String? name;
    final String? brand;
    final String? description;
    final String? rentalPricePerDay;
    final String? status;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic fotoCamera;

    Data({
        this.id,
        this.name,
        this.brand,
        this.description,
        this.rentalPricePerDay,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.fotoCamera,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        brand: json["brand"],
        description: json["description"],
        rentalPricePerDay: json["rental_price_per_day"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        fotoCamera: json["foto_camera"],
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
    };
}
