import 'dart:convert';

import 'package:http/http.dart' as http;

class ProductApiService {
  final http.Client _client;

  ProductApiService(this._client);

  Future<List<dynamic>> fetchProducts() async {
    final response = await _client.get(
      Uri.parse('https://fakestoreapi.com/products'),
    );
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const FormatException('Ürün listesi bekleniyordu.');
    }
    return decoded;
  }
}
