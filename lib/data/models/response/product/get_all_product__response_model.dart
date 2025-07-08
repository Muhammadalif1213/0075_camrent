import 'dart:convert';

class GetAllProductRequestModel {
  final String? message;
  final List<Datum>? data;

  GetAllProductRequestModel({this.message, this.data});

  factory GetAllProductRequestModel.fromJson(String str) =>
      GetAllProductRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAllProductRequestModel.fromMap(Map<String, dynamic> json) =>
      GetAllProductRequestModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class Datum {
  final int? id;
  final String? name;
  final String? brand;
  final String? description;
  final String? rentalPricePerDay;
  final String? imageUrl;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Datum({
    this.id,
    this.name,
    this.brand,
    this.description,
    this.rentalPricePerDay,
    this.imageUrl,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    brand: json["brand"],
    description: json["description"],
    rentalPricePerDay: json["rental_price_per_day"],
    imageUrl: json["image_url"],
    status: json["status"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "brand": brand,
    "description": description,
    "rental_price_per_day": rentalPricePerDay,
    "image_url": imageUrl,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
