import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:paml_camrent/data/models/request/product/add_product_request_model.dart';
import 'package:paml_camrent/data/models/response/product/add_product_response.dart';
import 'package:paml_camrent/data/models/response/product/get_all_product__response_model.dart';
import 'package:paml_camrent/services/services_http_client.dart';

class ProductRepository {
  final ServicesHttpClient _serviceHttpClient;

  ProductRepository(this._serviceHttpClient);

  Future<Either<String, AddProductResponseModel>> createProduct(
    AddProductRequestModel model,
  ) async {
    try {
      final response = await _serviceHttpClient.postWithToken(
        'cameras', // pastikan endpoint ini benar
        model.toMap(),
      );
      log("Create Product Response: ${response.body}");
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 201) {
        log("Create Product JSON Response: $jsonResponse");
        final cameraResponse = AddProductResponseModel.fromMap(jsonResponse); 
        // final cameraResponse = jsonResponse['message'] as String;
        log("Create Product Model: ${cameraResponse}");
        return Right(cameraResponse);
      } else {
        final errorMessage = json.decode(response.body);
        return Left(errorMessage['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      return Left("An error occurred while creating the product: $e");
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
}
