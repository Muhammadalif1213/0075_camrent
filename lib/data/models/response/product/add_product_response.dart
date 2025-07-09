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
  final int? id;
  final String? name;
  final String? brand;
  final String? description;
  final int? rentalPricePerDay;
  final String? status;
  final dynamic fotoCameraBase64;

  Data({
    this.id,
    this.name,
    this.brand,
    this.description,
    this.rentalPricePerDay,
    this.status,
    this.fotoCameraBase64,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    brand: json["brand"],
    description: json["description"],
    rentalPricePerDay: json["rental_price_per_day"] is int
        ? json["rental_price_per_day"]
        : int.tryParse(json["rental_price_per_day"].toString()),
    status: json["status"],
    fotoCameraBase64: json["foto_camera_base64"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "brand": brand,
    "description": description,
    "rental_price_per_day": rentalPricePerDay,
    "status": status,
    "foto_camera_base64": fotoCameraBase64,
  };
}
