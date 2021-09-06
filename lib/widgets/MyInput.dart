import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class MyInput extends StatelessWidget {
  const MyInput({
    Key key,
    @required TextEditingController controller,
    @required String hintText,
    @required MultiValidator multiValidator,
    bool obscureText,
  }) : _controller = controller, _hintText = hintText, _multiValidator = multiValidator, _obscureText = obscureText, super(key: key);

  final String _hintText;
  final TextEditingController _controller;
  final MultiValidator _multiValidator;
  final bool _obscureText;

  @override
  Widget build(BuildContext context) {
    bool _toObscure;
    if(_obscureText==null)
      _toObscure = false;
    else
      _toObscure = true;

    return
      Container(
        margin: const EdgeInsets.only(left:10.0, right: 10.0),
      child: TextFormField(
        // style: theme.textTheme.bodyText1,
        controller: _controller,
        obscureText: _toObscure,
        decoration: InputDecoration(
          hintText: _hintText,
          errorMaxLines: 2
        ),
        validator: _multiValidator
    ));
  }
}
