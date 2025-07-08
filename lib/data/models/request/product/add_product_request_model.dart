import 'dart:convert';

class AddProductRequestModel {
    final String? name;
    final String? brand;
    final String? description;
    final int? rentalPricePerDay;
    final String? imageUrl;

    AddProductRequestModel({
        this.name,
        this.brand,
        this.description,
        this.rentalPricePerDay,
        this.imageUrl,
    });

    factory AddProductRequestModel.fromJson(String str) => AddProductRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AddProductRequestModel.fromMap(Map<String, dynamic> json) => AddProductRequestModel(
        name: json["name"],
        brand: json["brand"],
        description: json["description"],
        rentalPricePerDay: json["rental_price_per_day"],
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "brand": brand,
        "description": description,
        "rental_price_per_day": rentalPricePerDay,
        "image_url": imageUrl,
    };
}
