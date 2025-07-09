import 'dart:convert';

class ProduGetAllProductResponseModel {
  final String? message;
  final List<Datum>? data;

  ProduGetAllProductResponseModel({this.message, this.data});

  factory ProduGetAllProductResponseModel.fromJson(String str) =>
      ProduGetAllProductResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProduGetAllProductResponseModel.fromMap(Map<String, dynamic> json) =>
      ProduGetAllProductResponseModel(
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
