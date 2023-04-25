import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:walletapp/apiConstant.dart';
import 'package:walletapp/homescreen/notificationScreen.dart';
import 'package:walletapp/homescreen/topupScreen.dart';
import 'package:walletapp/models/viewTransactionModel.dart';
import 'package:http/http.dart' as http;

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Transaction>? transaction;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      setState(() {
        final transactionJson = json.decode(response.body);
        transaction = List<Transaction>.from(
            transactionJson.map((data) => Transaction.fromJson(data)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 172, 27),
        title: const Text("Rp.0"),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 25,
        ),
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
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[200]!,
                            spreadRadius: 10.0,
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: Center(
                        child: transaction == null
                            ? const CircularProgressIndicator()
                            : ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: transaction!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final datas = transaction![index];
                                  return ListTile(
                                    title: Text(datas.transactionId),
                                    subtitle: Text('Amount: ${datas.amount}'),
                                  );
                                },
                              ),
                      ),
                    ),
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
