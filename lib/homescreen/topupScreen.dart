// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';

class TopupScreen extends StatefulWidget {
  const TopupScreen({super.key});

  @override
  State<TopupScreen> createState() => _TopupScreenState();
}

class _TopupScreenState extends State<TopupScreen> {
  @override
  Widget build(BuildContext context) {
    String randomNumber = '';
    for (int i = 0; i < 16; i++) {
      randomNumber += Random().nextInt(10).toString();
    }
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
                'Virtual Account: $randomNumber',
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
