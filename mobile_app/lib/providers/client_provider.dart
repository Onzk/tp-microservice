import 'package:billing_app/entities/client.dart';
import 'package:billing_app/services/client_service.dart';
import 'package:flutter/foundation.dart';

class ClientProvider with ChangeNotifier {
  final ClientService _clientService = ClientService();
  List<Client>? _clients = [];

  List<Client>? get clients => _clients;

  Future<void> fetchClients() async {
    try {
      _clients = await _clientService.getClients();
      notifyListeners();
    } catch (e) {
      //
    }
  }

  Future<Client?> addClient(Client client) async {
    try {
      final newClient = await _clientService.createClient(client);
      if (newClient != null) _clients?.add(newClient);
      notifyListeners();
      return newClient;
    } catch (e) {
      //
    }
    return null;
  }

  Future<Client?> updateClient(Client client) async {
    try {
      final updatedClient = await _clientService.updateClient(client);
      final index =
          _clients?.indexWhere((t) => t.id == updatedClient?.id) ?? -1;
      if (index != -1) {
        _clients?[index] = updatedClient!;
        notifyListeners();
        return updatedClient;
      }
    } catch (e) {
      //
    }
    return null;
  }

  Future<bool> deleteClient(int id) async {
    try {
      await _clientService.deleteClient(id);
      _clients?.removeWhere((client) => client.id == id);
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }
}
