import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

import 'package:test_auth_with_rolebased_ui/pages/SignInPage.dart';
import 'package:test_auth_with_rolebased_ui/services/AuthService.dart';
import 'package:test_auth_with_rolebased_ui/Utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(hintText: "Password"),
                      validator: MultiValidator([
                        RequiredValidator(errorText: returnValidationError(ValidationError.isRequired)),
                        MinLengthValidator(6, errorText: returnValidationError(ValidationError.shortPassword)),
                        PatternValidator(passwordRegex, errorText: returnValidationError(ValidationError.weakPassword))
                      ]),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: _firstNameController,
                      obscureText: true,
                      decoration: InputDecoration(hintText: "First name"),
                      validator: RequiredValidator(errorText: returnValidationError(ValidationError.isRequired)),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: _lastNameController,
                      obscureText: true,
                      decoration: InputDecoration(hintText: "Last name"),
                      validator: RequiredValidator(errorText: returnValidationError(ValidationError.isRequired)),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            var result = await context.read<AuthService>()
                                .signUp(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                                firstName: _firstNameController.text.trim(),
                                lastName: _lastNameController.text.trim()
                            );
                            // if(result.toString() == 'user-not-found')
                            print(result);
                            print(result.authReturn());
                            //TODO: Change basic snackbars to something prettier
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(result.authReturn()),
                              duration: Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'OK',
                                onPressed: () {},
                              ),
                            ));
                            if (result == 'signed-up')
                              Navigator.pop(context,
                                  MaterialPageRoute(builder: (context) {
                                    return SignInPage();
                                  }));
                          }
                          else {
                            print('Error');
                          }
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

                  ),
                )

            )
        )
    );
  }
}

