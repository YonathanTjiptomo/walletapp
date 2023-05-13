import 'package:flutter/material.dart';
import 'package:walletapp/chatpage/submitattachmentpage.dart';

class AttachmentPage extends StatefulWidget {
  const AttachmentPage({super.key});

  @override
  State<AttachmentPage> createState() => _AttachmentPageState();
}

class _AttachmentPageState extends State<AttachmentPage> {
  static List<String> profilelist = ["Money"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attachment'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 240, 172, 27),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SubmitAttachment()));
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 17, bottom: 17, left: 12),
                  decoration: const BoxDecoration(
                      border: Border(
                    bottom: BorderSide(),
                  )),
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
      ),
    );
  }
}
