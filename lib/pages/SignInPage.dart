import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:test_auth_with_rolebased_ui/services/AuthService.dart';

import 'SignUpPage.dart';

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
                          var result = context.read<AuthService>().signIn(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim());
                          print(result);
                          // po staremu
                          // auth.signInWithEmailAndPassword(
                          //     email: _emailController.text,
                          //     password: _passwordController.text);
                        },
                        child: Text('SignIn')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Nie masz konta?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => SignUpPage()));
                          },
                          child: Text(
                            "Zarestruj się",
                            style: TextStyle(color: Color.fromRGBO(112, 35, 238, 1)),
                          ))
                    ],
                  ),
                ]
                )
            )
        )
    );
  }
}