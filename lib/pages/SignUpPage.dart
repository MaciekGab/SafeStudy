import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

import 'package:test_auth_with_rolebased_ui/pages/SignInPage.dart';
import 'package:test_auth_with_rolebased_ui/services/AuthService.dart';
import 'package:test_auth_with_rolebased_ui/Utils.dart';
import 'package:test_auth_with_rolebased_ui/widgets/MyInput.dart';
import 'package:test_auth_with_rolebased_ui/widgets/RoundedElevatedButton.dart';

import '../backgroundGradient.dart';

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
    final theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return  SafeArea(
        child: Container(
          decoration: buildBoxDecoration(theme),
          child: Scaffold(
            backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(height: 0.22 * size.height,),
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(
                                "Safe Study",
                                style: TextStyle(
                                    fontSize: 56,
                                    color: theme.colorScheme.primary),
                              ),
                            ]),
                            SizedBox(height: 0.05 * size.height,),
                        MyInput(controller: _emailController, hintText: 'Email', multiValidator: MultiValidator([
                              RequiredValidator(errorText: returnValidationError(ValidationError.isRequired)),
                              EmailValidator(errorText: returnValidationError(ValidationError.invalidEmail))
                            ])
                        ),
                        SizedBox(height: 10.0),
                        MyInput(controller: _passwordController, obscureText: true, hintText: 'Password', multiValidator: MultiValidator([
                            RequiredValidator(errorText: returnValidationError(ValidationError.isRequired)),
                            MinLengthValidator(6, errorText: returnValidationError(ValidationError.shortPassword)),
                            PatternValidator(passwordRegex, errorText: returnValidationError(ValidationError.weakPassword))
                          ]),
                        ),
                        SizedBox(height: 10.0),
                        MyInput(
                          controller: _firstNameController,
                          obscureText: true,
                          hintText: 'First name',
                          multiValidator: MultiValidator([RequiredValidator(errorText: returnValidationError(ValidationError.isRequired))]),
                        ),
                        SizedBox(height: 10.0),
                        MyInput(
                          controller: _lastNameController,
                          obscureText: true,
                          hintText: 'Last name',
                          multiValidator: MultiValidator([RequiredValidator(errorText: returnValidationError(ValidationError.isRequired))]),
                        ),
                            SizedBox(height: 0.005 * size.height,),
                            RoundedElevatedButton(alignment: Alignment.centerRight, onPressed: () async {
                              await signUpAction(context);
                            }, child:Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(' Sign Up '),
                                Icon(Icons.login),
                              ],
                            ),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?"),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context,
                                    MaterialPageRoute(builder: (context) {return SignInPage();},),
                                  );
                                },
                                child: Text('Sign in', style: TextStyle(color: theme.colorScheme.primaryVariant)))
                          ],),]
                      ),
                    )
                ),
              )
          ),
        )
    );
  }

  Future<void> signUpAction(BuildContext context) async {
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
  }
}

