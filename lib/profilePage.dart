// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  static List<String> profilelist = ["Logout"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Account'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 240, 172, 27),
          bottom: AppBar(
            backgroundColor: Colors.white,
            title: Text(user.email!),
            titleTextStyle: const TextStyle(color: Colors.black),
            leading: Row(children: [
              SizedBox(
                width: 60,
                height: 50,
                child: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 240, 172, 27),
                  child: Text(user.email![0]),
                ),
              )
            ]),
            leadingWidth: 60,
            toolbarHeight: 70,
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding:
                        const EdgeInsets.only(top: 17, bottom: 17, left: 12),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(),
                      ),
                    ),
                    child: Text(
                      profilelist[0],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
