// ignore_for_file: file_names

import 'dart:convert';

Money moneyFromJson(String str) => Money.fromJson(json.decode(str));

String moneyToJson(Money data) => json.encode(data.toJson());

class Money {
  int id;
  String userId;
  int amount;
  DateTime createdDt;
  DateTime updatedDt;

  Money({
    required this.id,
    required this.userId,
    required this.amount,
    required this.createdDt,
    required this.updatedDt,
  });

  factory Money.fromJson(Map<String, dynamic> json) => Money(
        id: json["id"],
        userId: json["userId"],
        amount: json["amount"],
        createdDt: DateTime.parse(json["createdDt"]),
        updatedDt: DateTime.parse(json["updatedDt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "amount": amount,
        "createdDt": createdDt.toIso8601String(),
        "updatedDt": updatedDt.toIso8601String(),
      };
}
