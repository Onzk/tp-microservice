import 'dart:convert';

import 'package:billing_app/entities/client.dart';
import 'package:billing_app/properties.dart';
import 'package:http/http.dart' as http;

class ClientService {
  final String baseUrl = '$propApiURL/CLIENT-SERVICE/clients-rest';

  Future<List<Client>?> getClients() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(utf8.decode(response.bodyBytes))['data'];
      return jsonResponse.map((client) => Client.fromJson(client)).toList();
    }
    return null;
  }

  Future<Client?> createClient(Client client) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(client.toJson()),
    );
    if (response.statusCode == 200) {
      return Client.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }
    return null;
  }

  Future<Client?> updateClient(Client client) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${client.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(client.toJson()),
    );
    if (response.statusCode == 200) {
      return Client.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }
    return null;
  }

  Future<void> deleteClient(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete Client');
    }
  }
}
