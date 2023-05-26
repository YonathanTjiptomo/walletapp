import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walletapp/apiConstant.dart';
import 'package:walletapp/chatpage/chatDetailPage.dart';
import 'package:http/http.dart' as http;
import 'package:walletapp/models/friendlistmodel.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _textController = TextEditingController();
  List<TbFriend>? friend;

  @override
  void initState() {
    super.initState();
    getFriend();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> getFriend() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found.');
    }
    final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint6}/get-friend?uid=${user.uid}');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      setState(() {
        final friendJson = json.decode(response.body);
        friend = List<TbFriend>.from(
            friendJson.map((data) => TbFriend.fromJson(data)));
      });
    }
  }

  Future<void> addFriend() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found.');
    }
    final response = await http.post(
      Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint6}/add-friend?uid=${user.uid}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': _textController.text}),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 172, 27),
        title: const Text('Conversation'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  friend == null
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          height: 350,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: friend!.length,
                            itemBuilder: (BuildContext context, int index) {
                              final datas = friend![index];
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatDetailPage(
                                            userIdFriend:
                                                friend![index].userIdFriend),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                      title: Text(datas.userIdFriend),
                                      contentPadding: const EdgeInsets.all(8),
                                      shape: const Border(
                                          bottom: BorderSide(
                                              width: 1, color: Colors.black))));
                            },
                          ),
                        ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Add Friend",
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey.shade100),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                IconButton(
                  onPressed: () async {
                    addFriend();
                    getFriend();
                  },
                  color: Colors.blue,
                  icon: const Icon(Icons.add_circle),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
