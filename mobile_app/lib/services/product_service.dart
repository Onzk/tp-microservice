import 'dart:convert';

import 'package:billing_app/entities/product.dart';
import 'package:billing_app/properties.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String baseUrl = '$propApiURL/PRODUCT-SERVICE/products-rest';

  Future<Product?> findProduct(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));
    if (response.statusCode == 200) {
      return Product.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }
    return null;
  }

  Future<List<Product>?> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(utf8.decode(response.bodyBytes))['data'];
      return jsonResponse.map((product) => Product.fromJson(product)).toList();
    }
    return null;
  }

  Future<Product?> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (response.statusCode == 200) {
      return Product.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }
    return null;
  }

  Future<Product?> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    if (response.statusCode == 200) {
      return Product.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }
    return null;
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete Product');
    }
  }
}
