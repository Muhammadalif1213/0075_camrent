import 'dart:convert';

class AddProductResponseModel {
  final String? message;
  final Data? data;

  AddProductResponseModel({this.message, this.data});

  factory AddProductResponseModel.fromJson(String str) =>
      AddProductResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddProductResponseModel.fromMap(Map<String, dynamic> json) =>
      AddProductResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {"message": message, "data": data?.toMap()};
}

class Data {
  final String? name;
  final String? brand;
  final String? description;
  final int? rentalPricePerDay;
  final String? imageUrl;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  Data({
    this.name,
    this.brand,
    this.description,
    this.rentalPricePerDay,
    this.imageUrl,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    name: json["name"],
    brand: json["brand"],
    description: json["description"],
    rentalPricePerDay: json["rental_price_per_day"],
    imageUrl: json["image_url"],
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "brand": brand,
    "description": description,
    "rental_price_per_day": rentalPricePerDay,
    "image_url": imageUrl,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
