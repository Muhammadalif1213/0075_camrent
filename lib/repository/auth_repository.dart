import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:paml_camrent/data/models/request/auth/login_request_model.dart';
import 'package:paml_camrent/data/models/request/auth/register_request_model.dart';
import 'package:paml_camrent/data/models/response/auth_response_model.dart';
import 'package:paml_camrent/services/services_http_client.dart';

class AuthRepository {
  final ServicesHttpClient _serviceHttpClient;
  final secureStorage = FlutterSecureStorage();

  AuthRepository(this._serviceHttpClient);

  /// Login
  Future<Either<String, AuthResponseModel>> login(
    LoginRequestModel model,
  ) async {
    try {
      final response = await _serviceHttpClient.post('login', model.toMap());

      final jsonResponse = json.decode(response.body);
      print("LOGIN RESPONSE: $jsonResponse");
      if (response.statusCode == 200) {
        final loginResponse = AuthResponseModel.fromMap(jsonResponse);
        print("LOGIN RESPONSE MODEL: ${loginResponse.user}");

        // PERBAIKAN: Lakukan pengecekan null yang aman di sini
        if (loginResponse.user != null && loginResponse.user!.token != null) {
          // Hanya jika user dan token TIDAK NULL, baru kita simpan
          await secureStorage.write(
            key: "authToken",
            value: loginResponse.user!.token,
          );
          await secureStorage.write(
            key: "userRole",
            value: loginResponse.user!.role,
          );
          log("Login successful: Token and Role saved.");
          return Right(loginResponse); // Kembalikan data sukses
        } else {
          // Kasus aneh: Status 200 tapi tidak ada data user/token di response
          final errorMessage =
              "Login success but no user data received from server.";
          log(errorMessage);
          return Left(
            errorMessage,
          ); // Anggap sebagai kegagalan dan kirim pesan error
        }
      } else {
        // Blok ini sudah benar, tidak perlu diubah
        log("Login failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Login failed");
      }
    } catch (e) {
      log("Error in login: $e");
      return Left("An error occurred while logging in.");
    }

    //   // Debug print
    //   print("LOGIN STATUS: ${response.statusCode}");
    //   print("LOGIN BODY: ${response.body}");

    //   final jsonResponse = json.decode(response.body);

    //   if (response.statusCode == 200) {
    //     final authResponse = AuthResponseModel.fromMap(jsonResponse);
    //     final token = authResponse.user?.token;

    //     if (token != null) {
    //       await secureStorage.write(key: 'token', value: token);
    //     }

    //     return Right(authResponse);
    //   } else {
    //     return Left(jsonResponse["message"] ?? "Login gagal. Status ${response.statusCode}");
    //   }
    // } on SocketException {
    //   return const Left("Tidak bisa terhubung ke server. Periksa koneksi internet atau IP server.");
    // } on FormatException {
    //   return const Left("Format data dari server tidak valid.");
    // } on HttpException {
    //   return const Left("Terjadi kesalahan saat terhubung ke server.");
    // } catch (e) {
    //   return Left("Terjadi kesalahan: $e");
  }

  // Register
  Future<Either<String, String>> register(
    RegisterRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.post(
        "register",
        requestModel.toMap(),
      );
      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 201) {
        final registerResponse = jsonResponse['message'] as String;
        log("Registration successful: $registerResponse");
        return Right(registerResponse);
      } else {
        log("Registration failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Registration failed");
      }
    } catch (e) {
      log("Error in registration: $e");
      return Left("An error occurred while registering.");
    }
  }
}
