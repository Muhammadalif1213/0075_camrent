import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:paml_camrent/data/models/request/product/add_product_request_model.dart';
import 'package:paml_camrent/data/models/response/product/add_product_response.dart';
import 'package:paml_camrent/data/models/response/product/get_all_product__response_model.dart';
import 'package:paml_camrent/services/services_http_client.dart';

class ProductRepository {
  final ServicesHttpClient _serviceHttpClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ProductRepository(this._serviceHttpClient);

  /// Tambah Produk (dengan gambar)
  Future<Either<String, AddProductResponseModel>> createProduct(
    AddProductRequestModel model,
  ) async {
    try {
      final token = await _secureStorage.read(key: "authToken");
      final uri = Uri.parse("${_serviceHttpClient.baseUrl}cameras");

      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields['name'] = model.name ?? ''
        ..fields['brand'] = model.brand ?? ''
        ..fields['description'] = model.description ?? ''
        ..fields['rental_price_per_day'] =
            model.rentalPricePerDay?.toString() ?? ''
        ..fields['status'] = model.status ?? '';

      if (model.fotoCamera != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'foto_camera',
            model.fotoCamera!.path,
          ),
        );
      }

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();
      print('Response status: ${streamedResponse.statusCode}');

      if (streamedResponse.statusCode == 201) {
        final parsed = json.decode(responseBody);
        final responseModel = AddProductResponseModel.fromMap(parsed);
        return Right(responseModel);
      } else {
        final error = json.decode(responseBody);
        return Left(error['message'] ?? 'Gagal menyimpan produk');
      }
    } catch (e) {
      return Left("Terjadi kesalahan saat menambahkan produk: $e");
    }
  }

  Future<Either<String, Datum>> getDetailProduct(int id) async {
    try {
      final response = await _serviceHttpClient.get('cameras/$id');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['data'] != null) {
          final product = Datum.fromMap(jsonResponse['data']);
          return Right(product);
        } else {
          return Left("Produk tidak ditemukan");
        }
      } else {
        final jsonResponse = json.decode(response.body);
        return Left(jsonResponse['message'] ?? 'Gagal mengambil detail produk');
      }
    } catch (e) {
      return Left("Terjadi kesalahan saat mengambil detail produk: $e");
    }
  }

  Future<List<Datum>> getAllProducts() async {
    final response = await _serviceHttpClient.get(
      'cameras',
    ); // endpoint sesuai API

    if (response.statusCode == 200) {
      final result = ProduGetAllProductResponseModel.fromJson(response.body);
      return result.data ?? [];
    } else {
      throw Exception('Gagal mengambil data produk: ${response.body}');
    }
  }

  Future<Either<String, String>> deleteProduct(int id) async {
    try {
      final response = await _serviceHttpClient.deleteWithToken('cameras/$id');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Right(jsonResponse['message'] ?? 'Produk berhasil dihapus');
      } else {
        final jsonResponse = jsonDecode(response.body);
        return Left(jsonResponse['message'] ?? 'Gagal menghapus produk');
      }
    } catch (e) {
      return Left('Terjadi kesalahan saat menghapus produk: $e');
    }
  }

  /// UPDATE product with multipart
  Future<Either<String, AddProductResponseModel>> updateProduct({
    required int id,
    required AddProductRequestModel model,
    File? imageFile, // boleh null
  }) async {
    try {
      final token = await _secureStorage.read(key: "authToken");
      final uri = Uri.parse("${_serviceHttpClient.putWithToken}cameras/$id");

      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['_method'] = 'PUT'
        ..fields['name'] = model.name ?? ''
        ..fields['brand'] = model.brand ?? ''
        ..fields['description'] = model.description ?? ''
        ..fields['rental_price_per_day'] =
            model.rentalPricePerDay?.toString() ?? ''
        ..fields['status'] = model.status ?? 'available';

      // if (imageFile != null) {
      //   request.files.add(
      //     await http.MultipartFile.fromPath('foto_camera', imageFile.path),
      //   );
      // }

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();
      final responseCode = streamedResponse.statusCode;

      log('Response Code: $responseCode');
      log('Response Body: $responseBody');

      final decoded = json.decode(responseBody);
      if (responseCode == 200) {
        return Right(AddProductResponseModel.fromMap(decoded));
      } else {
        return Left(decoded['message'] ?? 'Gagal memperbarui produk');
      }
    } catch (e) {
      return Left("Terjadi kesalahan saat update produk: $e");
    }
  }
}
