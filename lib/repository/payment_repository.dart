import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:paml_camrent/data/models/request/payment/add_payment_request_model.dart';
import 'package:paml_camrent/data/models/response/payment/add_payment_response_model.dart';
import 'package:paml_camrent/services/services_http_client.dart';

class PaymentRepository {
  final ServicesHttpClient _serviceHttpClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  PaymentRepository(this._serviceHttpClient);

  Future<Either<String, AddPaymentResponseModel>> addPayment(
    AddPaymentRequestModel model,
  ) async {
    try {
      final token = await _secureStorage.read(key: "authToken");
      final uri = Uri.parse(
        "${_serviceHttpClient.baseUrl}bookings/${model.bookingId}/payments",
      );

      final request = http.MultipartRequest("POST", uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields['amount'] = model.amount;

      request.files.add(
        await http.MultipartFile.fromPath(
          'payment_proof',
          model.paymentProof.path,
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final parsed = json.decode(responseBody);
        final data = AddPaymentResponseModel.fromMap(parsed);
        return Right(data);
      }

      // 🔴 Tangani validasi gagal (422)
      if (response.statusCode == 422) {
        final error = json.decode(responseBody);
        print('Validation error: ${error['errors']}'); // log error lengkap
        final messages = (error['errors'] as Map<String, dynamic>).entries
            .map((e) => '${e.key}: ${(e.value as List).join(', ')}')
            .join('\n');
        return Left("Validasi gagal:\n$messages");
      }

      // 🔴 Tangani kesalahan umum lain
      final error = json.decode(responseBody);
      return Left(error['message'] ?? 'Gagal menambahkan pembayaran');
    } catch (e) {
      return Left("Terjadi kesalahan: $e");
    }
  }
}
