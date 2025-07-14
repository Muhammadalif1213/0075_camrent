class MyBookingResponseModel {
  final String? message;
  final int? statusCode;
  final List<BookingData>? data;

  MyBookingResponseModel({this.message, this.statusCode, this.data});

  factory MyBookingResponseModel.fromJson(Map<String, dynamic> json) {
    return MyBookingResponseModel(
      message: json['message'],
      statusCode: json['status_code'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BookingData.fromJson(e))
          .toList(),
    );
  }
}

class BookingData {
  final int? id;
  final int? userId;
  final String? startDate;
  final String? endDate;
  final String? totalPrice;
  final String? status;
  final String? paymentStatus;
  final String? paymentProofPath;
  final String? adminNotes;
  final List<Camera>? cameras;

  BookingData({
    this.id,
    this.userId,
    this.startDate,
    this.endDate,
    this.totalPrice,
    this.status,
    this.paymentStatus,
    this.paymentProofPath,
    this.adminNotes,
    this.cameras,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) => BookingData(
    id: json['id'],
    userId: json['user_id'],
    startDate: json['start_date'],
    endDate: json['end_date'],
    totalPrice: json['total_price'],
    status: json['status'],
    paymentStatus: json['payment_status'],
    paymentProofPath: json['payment_proof_path'],
    adminNotes: json['admin_notes'],
    cameras: (json['cameras'] as List<dynamic>?)
        ?.map((e) => Camera.fromJson(e))
        .toList(),
  );
}

class Camera {
  final int? id;
  final String? name;
  final String? brand;
  final String? description;
  final String? rentalPricePerDay;
  final String? status;

  Camera({
    this.id,
    this.name,
    this.brand,
    this.description,
    this.rentalPricePerDay,
    this.status,
  });

  factory Camera.fromJson(Map<String, dynamic> json) => Camera(
    id: json['id'],
    name: json['name'],
    brand: json['brand'],
    description: json['description'],
    rentalPricePerDay: json['rental_price_per_day'],
    status: json['status'],
  );
}
