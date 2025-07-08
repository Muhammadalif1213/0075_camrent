import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:paml_camrent/data/models/request/product/add_product_request_model.dart';
import 'package:paml_camrent/data/models/response/product/add_product_response.dart';
import 'package:paml_camrent/services/services_http_client.dart';

class ProductRepository {
  final ServicesHttpClient _serviceHttpClient;

  ProductRepository(this._serviceHttpClient);

  Future<Data> createProduct(AddProductRequestModel model) async {
    final response = await _serviceHttpClient.postWithToken(
      'cameras', // pastikan endpoint ini benar
      model.toMap(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = AddProductResponseModel.fromJson(response.body);
      if (responseData.data != null) {
        return responseData.data!;
      } else {
        throw Exception('Produk berhasil dibuat, tapi data kosong.');
      }
    } else {
      throw Exception(
        'Gagal menambahkan produk. Status: ${response.statusCode}\nBody: ${response.body}',
      );
    }
  }
}