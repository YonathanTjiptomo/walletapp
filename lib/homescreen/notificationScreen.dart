// ignore_for_file: file_names

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walletapp/apiConstant.dart';
import 'package:walletapp/models/notificationmodel.dart';
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<TbNotification>? notifikasi;

  @override
  void initState() {
    super.initState();
    getNotification();
  }

  Future<void> getNotification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found.');
    }
    final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint7}?uid=${user.uid}');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      setState(() {
        final notificationJson = json.decode(response.body);
        notifikasi = List<TbNotification>.from(
            notificationJson.map((data) => TbNotification.fromJson(data)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
        backgroundColor: const Color.fromARGB(255, 240, 172, 27),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          ListView(
            physics: const ScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              notifikasi == null
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      height: 350,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: notifikasi!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final datas = notifikasi![index];
                          return ListTile(
                            title: Text(datas.pesanNotif),
                            contentPadding: const EdgeInsets.all(8),
                            shape: const Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.black)),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
