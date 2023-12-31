import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(
              height: 50,
            ),
            Image.asset(
              "assets/images/flutter.png",
              width: 100,
              height: 100,
            ),
            SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your number';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "PhoneNumber",
              ),
            ),
            SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: passwordController,
              //validator
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Password",
              ),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blue)),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    bool result = await fireBaseLogin(
                        emailController.text, passwordController.text);
                    if (result == true) {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString('email', emailController.text);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                    email: emailController.text,
                                  )));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("faild Login")),
                      );
                    }


                  }
                },
                child: Text("Login")),
            SizedBox(
              height: 50,
            ),
            Center(child: Text("Forgetpassword? NoYawa Tap me")),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 30,
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Center(child: Text("No Account? Sign Up")),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> fireBaseLogin(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }
    return false;
  }
}
