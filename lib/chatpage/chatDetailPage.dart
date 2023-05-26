// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walletapp/apiConstant.dart';
import 'package:walletapp/chatpage/attachmentpage.dart';
import 'package:http/http.dart' as http;

class ChatMessage extends StatefulWidget {
  const ChatMessage({
    required this.text,
    required this.animationController,
    Key? key,
  }) : super(key: key);
  final String text;
  final AnimationController animationController;

  @override
  ChatMessageState createState() => ChatMessageState();
}

class ChatMessageState extends State<ChatMessage>
    with SingleTickerProviderStateMixin {
  late final Animation<double> _animation;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = widget.animationController;
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.lightBlue[300],
                    ),
                    padding: const EdgeInsets.all(9),
                    child: Text(widget.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({Key? key, required this.userIdFriend})
      : super(key: key);

  final String userIdFriend;

  @override
  State<ChatDetailPage> createState() => ChatDetailPageState();
}

class ChatDetailPageState extends State<ChatDetailPage>
    with TickerProviderStateMixin {
  List<ChatMessage> _messages = [];

  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;
  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    var newMessage = ChatMessage(
      text: text,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, newMessage);
    });
    _focusNode.requestFocus();
    newMessage.animationController.forward();
  }

  Future<List<String>> getMessages() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found.');
    }
    final response = await http.post(
      Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint5}/get-message?uid=${user.uid}'),
      headers: {'Content-type': 'application/json'},
      body: jsonEncode({'userIdTo': widget.userIdFriend}),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final reversedMessages = List<String>.from(jsonResponse.reversed);
      return reversedMessages;
    } else {
      throw Exception('Failed to load messages');
    }
  }

  void sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found.');
    }
    var url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint5}/send-message?uid=${user.uid}');
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'message': _textController.text,
          'userIdTo': widget.userIdFriend
        }));
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to send money: ${response.statusCode}');
    }
  }

  List<ChatMessage> _getNewMessages(List<String> newMessageStrings) {
    return newMessageStrings
        .map((message) => ChatMessage(
              text: message,
              animationController: AnimationController(
                duration: const Duration(milliseconds: 700),
                vsync: this,
              ),
            ))
        .where((message) => mounted)
        .toList();
  }

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final newMessageStrings = await getMessages();
      if (newMessageStrings.isNotEmpty) {
        final newMessages = _getNewMessages(newMessageStrings);
        setState(() {
          _messages = newMessages;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        AttachmentPage(userIdFriend: widget.userIdFriend)));
              },
              child: Container(
                height: 31,
                width: 31,
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child:
                    const Icon(Icons.payments, color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 3),
            Expanded(
                child: TextField(
              controller: _textController,
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration(
                  hintText: 'Send a message',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100))),
              focusNode: _focusNode,
            )),
            IconButton(
              color: Colors.blue,
              icon: const Icon(Icons.send),
              onPressed: _isComposing
                  ? () async {
                      sendMessage();
                      _handleSubmitted(_textController.text);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 240, 172, 27),
        flexibleSpace: SafeArea(
            child: Container(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.black)),
              const SizedBox(width: 2),
              const CircleAvatar(
                maxRadius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.userIdFriend,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              )),
              const Icon(Icons.settings, color: Colors.black54),
            ],
          ),
        )),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          const Divider(
            height: 1.0,
          ),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}
