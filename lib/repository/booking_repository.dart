import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:paml_camrent/data/models/request/booking/add_booking_request_model.dart';
import 'package:paml_camrent/data/models/response/booking/add_booking_response_model.dart';
import 'package:paml_camrent/services/services_http_client.dart';

class BookingRepository {
  final ServicesHttpClient _serviceHttpClient;

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
}
