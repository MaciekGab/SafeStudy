import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Column(children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(hintText: "Enter email"),
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(hintText: "Enter password"),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          auth.signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text);
                        },
                        child: Text('SignIn'))
                ]
                )
            )
        )
    );
  }
}