import 'dart:convert';
import 'dart:io';

class RequirementResponseModel {
    final String? message;
    final Data? data;

    RequirementResponseModel({
        this.message,
        this.data,
    });

    factory RequirementResponseModel.fromJson(String str) => RequirementResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RequirementResponseModel.fromMap(Map<String, dynamic> json) => RequirementResponseModel(
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
    final int? userId;
    final DateTime? startDate;
    final DateTime? endDate;
    final String? totalPrice;
    final String? status;
    final dynamic adminNotes;
    final String? location;
    final File? idCardImagePath;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Data({
        this.id,
        this.userId,
        this.startDate,
        this.endDate,
        this.totalPrice,
        this.status,
        this.adminNotes,
        this.location,
        this.idCardImagePath,
        this.createdAt,
        this.updatedAt,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
        endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        totalPrice: json["total_price"],
        status: json["status"],
        adminNotes: json["admin_notes"],
        location: json["location"],
        idCardImagePath: json["id_card_image_path"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "total_price": totalPrice,
        "status": status,
        "admin_notes": adminNotes,
        "location": location,
        "id_card_image_path": idCardImagePath,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
