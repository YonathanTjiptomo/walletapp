// ignore_for_file: file_names

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:walletapp/apiConstant.dart';

class TopupScreen extends StatefulWidget {
  const TopupScreen({super.key});

  @override
  State<TopupScreen> createState() => _TopupScreenState();
}

class _TopupScreenState extends State<TopupScreen> {
  String virtualAccount = " ";

  @override
  void initState() {
    super.initState();
    getVirtualAccount();
  }

  Future<void> getVirtualAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found.');
    }
    final response = await http.get(Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint3}/get-va?uid=${user.uid}'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final virtualAccount = json['virtualAccount'];
      setState(() {
        this.virtualAccount = virtualAccount;
      });
    } else {
      throw Exception('Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 172, 27),
        centerTitle: true,
        title: const Text('Top up'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
          child: Column(
            children: [
              const Text(
                'Lakukan Topup dengan cara transfer dana ke nomor Virtual Account Mandiri berikut ini:',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Virtual Account: $virtualAccount',
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Saldo anda akan bertambah saat transfer dana berhasil.',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
