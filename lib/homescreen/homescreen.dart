import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:walletapp/apiConstant.dart';
import 'package:walletapp/homescreen/notificationScreen.dart';
import 'package:walletapp/homescreen/topupScreen.dart';
import 'package:walletapp/models/viewTransactionModel.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Transactions>? transaction;
  int amount = 0;

  @override
  void initState() {
    super.initState();
    getData();
    _getMoney();
  }

  Future<void> _getMoney() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found.');
    }
    final response = await http.get(Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint2}/get-money?uid=${user.uid}'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final amount = json['amount'] as int;
      setState(() {
        this.amount = amount;
      });
    } else {
      throw Exception('Failed to load money');
    }
  }

  Future<void> getData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found.');
    }
    final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}?uid=${user.uid}');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      setState(() {
        final transactionJson = json.decode(response.body);
        transaction = List<Transactions>.from(
            transactionJson.map((data) => Transactions.fromJson(data)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 172, 27),
        title: Text("Rp.$amount"),
        actions: <Widget>[
          IconButton(
              padding: const EdgeInsets.only(right: 20),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationScreen()));
              },
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 30,
              ))
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(243, 245, 248, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(18))),
                        padding: const EdgeInsets.all(8),
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TopupScreen()));
                            },
                            icon: Icon(
                              Icons.add_box_outlined,
                              color: Colors.blue.shade900,
                              size: 25,
                            )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Top up',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: const Text(
                      "Transaction History",
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      ListView(
                        physics: const ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: <Widget>[
                          transaction == null
                              ? const CircularProgressIndicator()
                              : SizedBox(
                                  height: 350,
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: transaction!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final datas = transaction![index];
                                      return ListTile(
                                        title: Text(datas.transactionId),
                                        subtitle:
                                            Text('Amount: ${datas.amount}'),
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
