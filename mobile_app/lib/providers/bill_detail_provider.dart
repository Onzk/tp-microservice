import 'package:billing_app/entities/bill.dart';
import 'package:billing_app/entities/bill_detail.dart';
import 'package:billing_app/providers/bill_provider.dart';
import 'package:billing_app/services/bill_detail_service.dart';
import 'package:flutter/foundation.dart';

class BillDetailProvider with ChangeNotifier {
  final BillDetailService _billDetailService = BillDetailService();
  final BillProvider _billProvider = BillProvider();

  List<BillDetail>? _billDetails = [];

  List<BillDetail>? get billDetails => _billDetails;

  Future<void> fetchBillDetails(int billId) async {
    try {
      Bill? bill = await _billProvider.fetchBill(billId);
      _billDetails = bill?.details;
      notifyListeners();
    } catch (e) {
      //
    }
  }

  Future<BillDetail?> addBillDetail(BillDetail billDetail) async {
    try {
      final newBillDetail =
          await _billDetailService.createBillDetail(billDetail);
      if (newBillDetail != null) {
        _billDetails =
            (await _billProvider.fetchBill(billDetail.billId))?.details;
      }
      notifyListeners();
      return newBillDetail;
    } catch (e) {
      //
    }
    return null;
  }

  Future<BillDetail?> updateBillDetail(BillDetail billDetail) async {
    try {
      final updatedBillDetail =
          await _billDetailService.updateBillDetail(billDetail);
      if (updatedBillDetail != null) {
        _billDetails =
            (await _billProvider.fetchBill(billDetail.billId))?.details;
      }
      notifyListeners();
      return updatedBillDetail;
    } catch (e) {
      //
    }
    return null;
  }

  Future<bool> deleteBillDetail(int id) async {
    try {
      await _billDetailService.deleteBillDetail(id);
      _billDetails?.removeWhere((billDetail) => billDetail.id == id);
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }
}
