import 'package:billing_app/entities/bill_detail.dart';
import 'package:billing_app/entities/client.dart';

class Bill {
  final int? id;
  int clientId;
  final String date;
  Client? client;
  List<BillDetail>? details;

  Bill({
    this.id,
    required this.clientId,
    required this.date,
    required this.client,
    required this.details,
  });

  String parsedDate() => date.toString().replaceAll("T", " ").split(".")[0];

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      clientId: json['client_id'] ?? 0,
      date: json['date'] ?? "--",
      client: json['client'] == null ? null : Client.fromJson(json['client']),
      details: ((json['details'] ?? []) as List)
          .map((de) => BillDetail.fromJson(de))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "client_id": clientId,
      "date": date,
      "id": id,
    };
  }
}
