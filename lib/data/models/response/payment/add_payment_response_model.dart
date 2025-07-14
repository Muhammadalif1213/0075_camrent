class AddPaymentResponseModel {
  final String message;
  final PaymentData data;

  AddPaymentResponseModel({
    required this.message,
    required this.data,
  });

  factory AddPaymentResponseModel.fromMap(Map<String, dynamic> json) =>
      AddPaymentResponseModel(
        message: json['message'],
        data: PaymentData.fromMap(json['data']),
      );
}

class PaymentData {
  final int id;
  final int bookingId;
  final String amount;
  final String proofUrl;
  final int confirmedByAdminId;
  final DateTime createdAt;

  PaymentData({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.proofUrl,
    required this.confirmedByAdminId,
    required this.createdAt,
  });

  factory PaymentData.fromMap(Map<String, dynamic> json) => PaymentData(
        id: json['id'],
        bookingId: json['booking_id'],
        amount: json['amount'],
        proofUrl: json['proof_url'],
        confirmedByAdminId: json['confirmed_by_admin_id'],
        createdAt: DateTime.parse(json['created_at']),
      );
}
