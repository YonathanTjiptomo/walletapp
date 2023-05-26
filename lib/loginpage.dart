// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:walletapp/apiConstant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
        centerTitle: true,
        title: const Text('Login Page'),
        backgroundColor: const Color.fromARGB(255, 240, 172, 27),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const SizedBox(height: 100),
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
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
        Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint3}/save-user'),
        body: {
          'email': email,
          'uid': uid,
        });

    if (response.statusCode == 200) {
    } else {
      throw Exception("Failed to send user data to server");
    }
  }
}
