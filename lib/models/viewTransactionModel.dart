// ignore_for_file: file_names

import 'dart:convert';

List<Transaction> transactionFromJson(String str) => List<Transaction>.from(
    json.decode(str).map((x) => Transaction.fromJson(x)));

String transactionToJson(List<Transaction> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Transaction {
  Transaction({
    required this.id,
    required this.transactionId,
    required this.amount,
    required this.transactionDate,
    required this.createdDt,
    required this.updatedDt,
    required this.description,
    required this.status,
  });

  int id;
  String transactionId;
  double amount;
  DateTime transactionDate;
  DateTime createdDt;
  DateTime updatedDt;
  String description;
  int status;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        transactionId: json["transactionId"],
        amount: json["amount"],
        transactionDate: DateTime.parse(json["transactionDate"]),
        createdDt: DateTime.parse(json["createdDt"]),
        updatedDt: DateTime.parse(json["updatedDt"]),
        description: json["description"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "transactionId": transactionId,
        "amount": amount,
        "transactionDate": transactionDate.toIso8601String(),
        "createdDt": createdDt.toIso8601String(),
        "updatedDt": updatedDt.toIso8601String(),
        "description": description,
        "status": status,
      };
}
