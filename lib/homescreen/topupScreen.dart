// ignore_for_file: file_names

import 'package:flutter/material.dart';

class TopupScreen extends StatelessWidget {
  const TopupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 172, 27),
        centerTitle: true,
        title: const Text('Top up'),
      ),
      body: Column(
        children: const <Widget>[
          Text(
            "Pilih Cara Top up",
            style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 2),
          ),
        ],
      ),
    );
  }
}
