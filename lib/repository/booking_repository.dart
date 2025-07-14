import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as _secureStorage;
import 'package:paml_camrent/data/models/request/booking/add_booking_request_model.dart';
import 'package:paml_camrent/data/models/response/booking/add_booking_response_model.dart';
import 'package:paml_camrent/data/models/response/booking/booking_response_model.dart';
import 'package:paml_camrent/data/models/response/booking/booking_history_response_model.dart';
import 'package:paml_camrent/data/models/response/booking/requirement_response_model.dart';
import 'package:paml_camrent/services/services_http_client.dart';

class BookingRepository {
  final ServicesHttpClient _serviceHttpClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  BookingRepository(this._serviceHttpClient);

  Future<Either<String, AddBookingResponseModel>> createBooking(
    AddBookingRequestModel model,
  ) async {
    try {
      final response = await _serviceHttpClient.postWithToken(
        'bookings',
        model.toMap(),
      );

      if (response.statusCode == 201) {
        final bookingResponse = AddBookingResponseModel.fromMap(
          json.decode(response.body),
        );
        return Right(bookingResponse);
      } else {
        final error =
            json.decode(response.body)['message'] ?? 'Gagal membuat booking';
        return Left(error);
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
  // Mengambil semua booking (untuk admin)
  Future<Either<String, List<Booking>>> getAllBookings() async {
    try {
      final response = await _serviceHttpClient.get('bookings');
      if (response.statusCode == 200) {
        final model = AdminBookingResponseModel.fromMap(
          json.decode(response.body),
        );
        return Right(model.data);
      } else {
        return Left(
          json.decode(response.body)['message'] ?? 'Gagal memuat data',
        );
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  // Mengupdate status booking
  Future<Either<String, String>> updateBookingStatus(
    int bookingId,
    String status,
  ) async {
    try {
      final response = await _serviceHttpClient.patchWithToken(
        'bookings/$bookingId/status',
        {'status': status},
      );
      if (response.statusCode == 200) {
        return Right(
          json.decode(response.body)['message'] ?? 'Status berhasil diubah',
        );
      } else {
        return Left(
          json.decode(response.body)['message'] ?? 'Gagal mengubah status',
        );
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
