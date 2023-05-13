// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:walletapp/apiConstant.dart';

class SubmitAttachment extends StatefulWidget {
  const SubmitAttachment({super.key});

  @override
  State<SubmitAttachment> createState() => _SubmitAttachmentState();
}

class _SubmitAttachmentState extends State<SubmitAttachment> {
  final amountController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found.');
    }
    var url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint5}/send-money?uid=${user.uid}');
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'amount': amountController.text,
          'message': messageController.text,
        }));
    // ignore: avoid_print
    if (response.statusCode == 200) {
      // ignore: void_checks
      return (jsonDecode(response.body));
    } else {
      throw Exception('Failed to send money: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Attachment'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 240, 172, 27),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 50),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  _submitForm();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text("Submit")),
          ],
        ),
      ),
    );
  }
}
