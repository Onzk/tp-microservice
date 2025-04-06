import 'dart:convert';

import 'package:billing_app/entities/bill_detail.dart';
import 'package:billing_app/properties.dart';
import 'package:billing_app/services/product_service.dart';
import 'package:http/http.dart' as http;

class BillDetailService {
  final String baseUrl = '$propApiURL/BILLING-SERVICE/bill-details-rest';

  Future<List<BillDetail>?> getBillDetails() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(utf8.decode(response.bodyBytes))['data'];
      List<BillDetail> details = jsonResponse
          .map((billDetail) => BillDetail.fromJson(billDetail))
          .toList();
      for (var detail in details) {
        detail.product = await ProductService().findProduct(detail.productId);
      }
      return details;
    }
    return null;
  }

  Future<BillDetail?> createBillDetail(BillDetail billDetail) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(billDetail.toJson()),
    );
    if (response.statusCode == 200) {
      return BillDetail.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }
    return null;
  }

  Future<BillDetail?> updateBillDetail(BillDetail billDetail) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${billDetail.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(billDetail.toJson()),
    );
    if (response.statusCode == 200) {
      return BillDetail.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }
    return null;
  }

  Future<void> deleteBillDetail(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete BillDetail');
    }
  }
}
