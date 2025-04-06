import 'package:billing_app/entities/product.dart';

class BillDetail {
  final int? id;
  final int billId;
  final int productId;
  final int quantity;
  final double price;
  Product? product;

  BillDetail({
    this.id,
    this.billId = 0,
    this.productId = 0,
    required this.quantity,
    required this.price,
    this.product,
  });

  factory BillDetail.fromJson(Map<String, dynamic> json) {
    return BillDetail(
      id: json['id'],
      price: double.parse(json['price'].toString()),
      product:
          json['product'] == null ? null : Product.fromJson(json['product']),
      quantity: int.parse(json['quantity'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'bill_id': billId,
      'quantity': quantity,
      'price': price,
    };
  }
}
