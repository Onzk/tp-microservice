import 'package:billing_app/entities/bill.dart';
import 'package:billing_app/services/bill_service.dart';
import 'package:flutter/foundation.dart';

class BillProvider with ChangeNotifier {
  final BillService _billService = BillService();
  List<Bill>? _bills;

  List<Bill>? get bills => _bills;

  Future<void> fetchBills() async {
    try {
      _bills = await _billService.getBills();
      notifyListeners();
    } catch (e) {
      _bills = null;
    }
  }

  Future<Bill?> fetchBill(int id) async {
    try {
      Bill? bill = await _billService.getBill(id);
      int index = _bills?.indexWhere((b) => b.id == id) ?? -1;
      if ((index != -1) && (bill != null)) {
        _bills?[index] = bill;
      }
      notifyListeners();
      return bill;
    } catch (e) {
      return null;
    }
  }

  Future<Bill?> addBill(Bill bill) async {
    try {
      final newBill = await _billService.createBill(bill);
      if (newBill != null) _bills?.add(newBill);
      _bills = await _billService.getBills();
      notifyListeners();
      return newBill;
    } catch (e) {
      //
    }
    return null;
  }

  Future<Bill?> updateBill(Bill bill) async {
    try {
      final updatedBill = await _billService.updateBill(bill);
      final index = _bills?.indexWhere((t) => t.id == updatedBill?.id) ?? -1;
      if (index != -1) {
        _bills?[index] = updatedBill!;
        _bills = await _billService.getBills();
        notifyListeners();
        return updatedBill;
      }
    } catch (e) {
      //
    }
    return null;
  }

  Future<bool> deleteBill(int id) async {
    try {
      await _billService.deleteBill(id);
      _bills?.removeWhere((bill) => bill.id == id);
      _bills = await _billService.getBills();
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }
}
