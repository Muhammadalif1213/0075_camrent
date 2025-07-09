import 'dart:convert';
import 'dart:io';

class AddProductRequestModel {
    final String? name;
    final String? brand;
    final String? description;
    final int? rentalPricePerDay;
    final File? fotoCamera;
    final String? status;

    AddProductRequestModel({
        this.name,
        this.brand,
        this.description,
        this.rentalPricePerDay,
        this.fotoCamera,
        this.status,
    });

    factory AddProductRequestModel.fromJson(String str) => AddProductRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AddProductRequestModel.fromMap(Map<String, dynamic> json) => AddProductRequestModel(
        name: json["name"],
        brand: json["brand"],
        description: json["description"],
        rentalPricePerDay: json["rental_price_per_day"],
        fotoCamera: json["foto_camera"],
        status: json["status"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "brand": brand,
        "description": description,
        "rental_price_per_day": rentalPricePerDay,
        "foto_camera": fotoCamera,
        "status": status,
    };
}
