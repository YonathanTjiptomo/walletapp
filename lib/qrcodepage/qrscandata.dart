// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:walletapp/apiConstant.dart';

class QrScanData extends StatefulWidget {
  const QrScanData({super.key});

  @override
  State<QrScanData> createState() => _QrScanDataState();
}

class _QrScanDataState extends State<QrScanData> {
  final TextEditingController amountController = TextEditingController();
  String transactionId = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 240, 172, 27),
        title: const Text("Qr Scan Data"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 100),
            Text("Transaction Id: $transactionId"),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: "Amount",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  makePayment(context);
                },
                child: const Text("Approve")),
          ],
        ),
      ),
    );
  }

  void makePayment(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found.');
    }
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint4);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'uid': user.uid,
          'amount': amountController.text,
        }));
    final json = jsonDecode(response.body);
    final transactionId = json['transactionId'];
    setState(() {
      this.transactionId = transactionId;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Transaction Details'),
          content: Text(
              'Transaction ID: $transactionId\nAmount: ${amountController.text}\nPayment Berhasil'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
