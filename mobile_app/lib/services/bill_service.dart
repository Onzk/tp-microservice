import 'dart:convert';

import 'package:billing_app/entities/bill.dart';
import 'package:billing_app/entities/bill_detail.dart';
import 'package:billing_app/entities/client.dart';
import 'package:billing_app/properties.dart';
import 'package:http/http.dart' as http;

class BillService {
  final String baseUrl = '$propApiURL/BILLING-SERVICE/bills-rest';

  Future<List<Bill>?> getBills() async {
    http.Response response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(utf8.decode(response.bodyBytes))['data'];
      List<Bill> bills =
          jsonResponse.map((bill) => Bill.fromJson(bill)).toList();
      for (Bill bill in bills) {
        response = await http.get(Uri.parse("$baseUrl/full/${bill.id}"));
        if (response.statusCode == 200) {
          var data = jsonDecode(utf8.decode(response.bodyBytes));
          bill.client =
              data['client'] == null ? null : Client.fromJson(data['client']);
          bill.details = ((data['details'] ?? []) as List)
              .map((de) => BillDetail.fromJson(de))
              .toList();
        }
      }
      return bills;
    }
    return null;
  }

  Future<Bill?> getBill(int id) async {
    http.Response response = await http.get(Uri.parse("$baseUrl/full/$id"));
    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return Bill.fromJson(data);
    }
    return null;
  }

  Future<Bill?> createBill(Bill bill) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(bill.toJson()),
    );
    if (response.statusCode == 200) {
      return Bill.fromJson(jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }
    return null;
  }

  Future<Bill?> updateBill(Bill bill) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${bill.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(bill.toJson()),
    );
    if (response.statusCode == 200) {
      return Bill.fromJson(jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }
    return null;
  }

  Future<void> deleteBill(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete Bill');
    }
  }
}
