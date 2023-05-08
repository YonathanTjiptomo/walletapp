// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:walletapp/apiConstant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late ScaffoldMessengerState scaffoldMessenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Firebase Auth'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential = await signInWithEmailPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  String? email = userCredential.user?.email;
                  String? uid = userCredential.user?.uid;
                  await sendUserData(email!, uid!);
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text("Logged in successfully"),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text("Failed to log in: ${e.message}"),
                    ),
                  );
                }
              },
              child: const Text("Log In"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential =
                      await registerWithEmailPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  String? email = userCredential.user?.email;
                  String? uid = userCredential.user?.uid;
                  await sendUserData(email!, uid!);
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text("Registered successfully"),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text("Failed to register: ${e.message}"),
                    ),
                  );
                }
              },
              child: const Text("Register"),
            ),
            const SizedBox(height: 20),
            SignInButton(
              Buttons.Google,
              onPressed: () async {
                try {
                  UserCredential userCredential = await _signInWithGoogle();
                  String? email = userCredential.user?.email;
                  String? uid = userCredential.user?.uid;
                  await sendUserData(email!, uid!);
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text("Logged in successfully"),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text("Failed to log in: ${e.message}"),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<UserCredential> registerWithEmailPassword(
      {required String email, required String password}) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithEmailPassword(
      {required String email, required String password}) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<void> sendUserData(String email, String uid) async {
    final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint3),
        body: {
          'email': email,
          'uid': uid,
        });

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print("Failed to send user data to server");
    }
  }
}
