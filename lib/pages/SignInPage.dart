import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:test_auth_with_rolebased_ui/services/AuthService.dart';
import 'package:test_auth_with_rolebased_ui/Utils.dart';
import 'package:test_auth_with_rolebased_ui/widgets/MyInput.dart';
import 'package:test_auth_with_rolebased_ui/widgets/RoundedElevatedButton.dart';
import '../backgroundGradient.dart';
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
    final theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        decoration: buildBoxDecoration(theme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
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
                          SizedBox(height: 0.20 * size.height,),
                          MyInput(controller: _emailController, hintText: 'Email',multiValidator: MultiValidator([
                            RequiredValidator(errorText: returnValidationError(ValidationError.isRequired)),
                            EmailValidator(errorText: returnValidationError(ValidationError.invalidEmail))
                          ]),),
                          SizedBox(height: 10.0),
                          MyInput(obscureText: true,controller: _passwordController, hintText: 'Password',multiValidator: MultiValidator([
                            RequiredValidator(errorText: returnValidationError(ValidationError.isRequired)),
                            MinLengthValidator(6, errorText: returnValidationError(ValidationError.shortPassword)),
                            PatternValidator(passwordRegex, errorText: returnValidationError(ValidationError.weakPassword))
                          ]),),
                          SizedBox(height: 0.005 * size.height,),
                          RoundedElevatedButton(alignment: Alignment.centerRight, onPressed: () async {
                            await signInAction();
                          }, child:Text(' Sign In '),
                            smallButton: true,
                            icon: Icons.login,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don’t have an account?"),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => SignUpPage()));
                                  },
                                  child: Text('Sign up', style: TextStyle(color: theme.colorScheme.primaryVariant),
                                  ))
                            ],
                          ),
                        ]
                    ),
                  )
              ),
          ),
          ),
        ),
    );
  }

  Future signInAction() async{
    if(_formKey.currentState.validate()){
      var result = await context.read<AuthService>().signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      print('the result of this is: $result');
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
  }

}