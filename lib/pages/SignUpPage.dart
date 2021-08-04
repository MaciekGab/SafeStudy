import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_auth_with_rolebased_ui/pages/SignInPage.dart';
import 'package:test_auth_with_rolebased_ui/services/AuthService.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _firstNameController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Enter first name"),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _lastNameController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Enter last name"),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        var result = await context.read<AuthService>().signUp(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                            firstName: _firstNameController.text.trim(),
                            lastName: _lastNameController.text.trim()
                        );
                        Navigator.pop(context,
                        MaterialPageRoute(builder: (context){return SignInPage();}));
                        // if(result.toString() == 'user-not-found')
                        print(result);

                        //po staremu
                        // auth.signInWithEmailAndPassword(
                        //     email: _emailController.text,
                        //     password: _passwordController.text);
                      },
                      child: Text('SignIn')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Masz już konto?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SignInPage();
                                },
                              ),
                            );
                          },
                          child: Text("Zaloguj się",
                              style: TextStyle(color: Color.fromRGBO(112, 35, 238, 1))))
                    ],
                  ),
                ]

                )

            )
        )
    );
  }
}

