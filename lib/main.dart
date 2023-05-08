import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:walletapp/chatpage/chatscreen.dart';
import 'package:walletapp/homescreen/homescreen.dart';
import 'package:walletapp/loginpage.dart';
import 'package:walletapp/profilePage.dart';
import 'package:walletapp/qrcode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: const Color.fromARGB(255, 240, 172, 27)),
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Row(children: [
              Visibility(
                visible: constraints.maxWidth >= 1200,
                child: Expanded(
                  child: Container(
                    height: double.infinity,
                    color: Theme.of(context).colorScheme.primary,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Firebase Auth Desktop',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: constraints.maxWidth >= 1200
                    ? constraints.maxWidth / 2
                    : constraints.maxWidth,
                child: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return const WalletApp();
                    }
                    return const LoginPage();
                  },
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}

class WalletApp extends StatefulWidget {
  const WalletApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WalletAppState createState() => _WalletAppState();
}

class _WalletAppState extends State<WalletApp> {
  var screens = [
    const Homescreen(),
    const ChatScreen(),
    const QrCode(),
    const ProfilePage(),
  ]; //screens for each tab

  int selectedTab = 0;

  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 172, 27),
      body: screens[selectedTab],
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                tooltip: 'Home',
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    selectedTab = 0;
                  });
                },
                icon: selectedTab == 0
                    ? const Icon(
                        Icons.home_filled,
                        color: Colors.white,
                        size: 35,
                      )
                    : const Icon(
                        Icons.home_outlined,
                        color: Colors.white,
                        size: 35,
                      )),
            IconButton(
                tooltip: 'Chat',
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    selectedTab = 1;
                  });
                },
                icon: selectedTab == 1
                    ? const Icon(
                        Icons.chat_bubble,
                        color: Colors.white,
                        size: 35,
                      )
                    : const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                        size: 35,
                      )),
            IconButton(
                tooltip: 'QR Code Scanner',
                enableFeedback: false,
                onPressed: () async {
                  setState(() {
                    selectedTab = 2;
                  });
                },
                icon: selectedTab == 2
                    ? const Icon(
                        Icons.qr_code_scanner_rounded,
                        color: Colors.white,
                        size: 35,
                      )
                    : const Icon(
                        Icons.qr_code_scanner_outlined,
                        color: Colors.white,
                        size: 35,
                      )),
            IconButton(
                tooltip: 'Profile',
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    selectedTab = 3;
                  });
                },
                icon: selectedTab == 3
                    ? const Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 35,
                      )
                    : const Icon(
                        Icons.account_circle_outlined,
                        color: Colors.white,
                        size: 35,
                      ))
          ],
        ),
      ),
    );
  }
}
