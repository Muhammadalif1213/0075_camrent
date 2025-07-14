import 'dart:io';

class AddPaymentRequestModel {
  final int bookingId;
  final String amount;
  final File paymentProof;

  AddPaymentRequestModel({
    required this.bookingId,
    required this.amount,
    required this.paymentProof,
  });
}
