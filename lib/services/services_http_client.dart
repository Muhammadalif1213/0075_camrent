import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ServicesHttpClient {
  final String baseUrl = 'http://10.0.2.2:8000/api/';
  final secureStorage = FlutterSecureStorage();

  //post
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$endpoint");
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-type': 'application/json',
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception("Post request failed: $e");
    }
  }

  //post WITH TOKEN
  Future<http.Response> postWithToken(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final token = await secureStorage.read(key: "authToken");
    final url = Uri.parse("$baseUrl$endpoint");
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-type': 'application/json',
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception("Post request failed: $e");
    }
  }

  // post WITH FILE (Multipart)
  Future<http.Response> postMultipartWithToken({
    required String endpoint,
    required Map<String, String> fields,
    required File file,
  }) async {
    final token = await secureStorage.read(key: "authToken");
    final uri = Uri.parse('$baseUrl$endpoint'); // <-- URL diperbaiki
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.fields.addAll(fields);
    request.files.add(
      await http.MultipartFile.fromPath(
        'foto_camera',
        file.path,
      ), // Sesuaikan 'fileFieldName'
    );

    // Ubah StreamedResponse menjadi Response biasa
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  //get
  Future<http.Response> get(String endpoint) async {
    final token = await secureStorage.read(key: "authToken");
    final url = Uri.parse("$baseUrl$endpoint");
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'content-type': 'application.json',
        },
      );
      return response;
    } catch (e) {
      throw Exception("Post request failed: $e");
    }
  }

  // Multipart PUT with Token (method override _method=PUT)
  Future<http.StreamedResponse> putMultipartWithToken({
    required String endpoint,
    required Map<String, String> fields,
    File? file,
    String? fileFieldName,
  }) async {
    final token = await secureStorage.read(key: "authToken");
    final uri = Uri.parse("$baseUrl$endpoint");

    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['_method'] = 'PUT'; // Laravel expects this for update
    request.fields.addAll(fields);

    if (file != null && fileFieldName != null) {
      request.files.add(
        await http.MultipartFile.fromPath(fileFieldName, file.path),
      );
    }

    return request.send();
  }

  // DELETE with Token
  Future<http.Response> deleteWithToken(String endpoint) async {
    final token = await secureStorage.read(key: "authToken");
    final url = Uri.parse("$baseUrl$endpoint");
    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return response;
    } catch (e) {
      throw Exception("DELETE request failed: $e");
    }
  }
}
