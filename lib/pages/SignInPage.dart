import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:test_auth_with_rolebased_ui/services/AuthService.dart';
import 'package:test_auth_with_rolebased_ui/Utils.dart';
import 'SignUpPage.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(hintText: "Email"),
                        validator: MultiValidator([
                          RequiredValidator(errorText: returnValidationError(ValidationError.isRequired)),
                          EmailValidator(errorText: returnValidationError(ValidationError.invalidEmail))
                        ])
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(hintText: "Hasło"),
                        validator: MultiValidator([
                          RequiredValidator(errorText: returnValidationError(ValidationError.isRequired)),
                          MinLengthValidator(6, errorText: returnValidationError(ValidationError.shortPassword)),
                          PatternValidator(passwordRegex, errorText: returnValidationError(ValidationError.weakPassword))
                        ]),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if(_formKey.currentState.validate()){
                              var result = await context.read<AuthService>().signIn(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim());
                              print('the result of this is: $result');
                              //TODO: Change basic snackbars to something prettier
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(result.authReturn()),
                                duration: Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'OK',
                                  onPressed: () { },
                                ),
                              ));
                            }
                            else{
                              print('Error');
                            }
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
                  ),
                )
            )
        )
    );
  }
}
