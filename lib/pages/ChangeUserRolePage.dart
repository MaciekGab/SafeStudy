import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:test_auth_with_rolebased_ui/services/DatabaseService.dart';
import 'package:test_auth_with_rolebased_ui/widgets/GradientAppBar.dart';
import 'package:test_auth_with_rolebased_ui/widgets/MyInput.dart';
import 'package:test_auth_with_rolebased_ui/widgets/RoundedElevatedButton.dart';
import 'package:test_auth_with_rolebased_ui/widgets/RoundedText.dart';

import '../utils/Utils.dart';

class ChangeUserRolePage extends StatefulWidget {
  @override
  _ChangeUserRolePageState createState() => _ChangeUserRolePageState();
}

class _ChangeUserRolePageState extends State<ChangeUserRolePage> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final _db = DatabaseService();
  String email = '', firstName = '', lastName = '', role = '', uid = '';
  bool isUserSearched = true;
  List<bool> isSelected = [false, false, false];
  final List<String> roles = ['admin', 'teacher', 'user'];
  String title = 'Edit';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return SafeArea(
        child: Scaffold(
            appBar: GradientAppBar(
              title: Text('Edit User'),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  Expanded( flex: 1, child: RoundedText(text: 'Edit', roundedSide: 'right', width: 0.4 * size.width, height: 0.1 * size.height, alignment: Alignment.centerLeft)),
                  Visibility(
                    visible: isUserSearched,
                    replacement: Expanded( flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ToggleButtons(
                            isSelected: isSelected,
                            children: [
                              Padding(padding: EdgeInsets.symmetric(horizontal: 0.05 * size.width), child: Text('admin')),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 0.05 * size.width), child: Text('teacher')),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 0.05 * size.width), child: Text('user')),
                            ],
                            selectedBorderColor: theme.colorScheme.primaryVariant,
                            borderColor: theme.colorScheme.primary,
                            borderWidth: 2,
                            borderRadius: BorderRadius.circular(30),
                            fillColor: theme.colorScheme.primary,
                            selectedColor: theme.colorScheme.background,
                            onPressed: (int newIndex) {
                              setState(() {
                                for (int index = 0;
                                    index < isSelected.length;
                                    index++)
                                  if (index == newIndex) {
                                    isSelected[index] = true;
                                  } else {
                                    isSelected[index] = false;
                                  }});},),
                          Form(
                              key: _formKey2,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  MyInput(
                                      controller: _firstNameController,
                                      hintText: 'First Name',
                                      multiValidator: MultiValidator([
                                        RequiredValidator(errorText: returnValidationError(ValidationError.isRequired)),])),
                                  SizedBox(height: 0.01*size.height),
                                  MyInput(
                                      controller: _lastNameController,
                                      hintText: 'Last Name',
                                      multiValidator: MultiValidator([
                                        RequiredValidator(errorText: returnValidationError(ValidationError.isRequired)),
                                      ])),],)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RoundedElevatedButton(child: Text(' Search '), onPressed: () {setState(() {
                                      isUserSearched = true;
                                    });}, alignment: Alignment.centerLeft, smallButton: true, icon: Icons.search_rounded),
                              RoundedElevatedButton(child: Text(' Update '), onPressed: () async {
                                    if(_formKey2.currentState.validate()) {
                                      await updateUserAction();
                                    }
                                  }, alignment: Alignment.centerRight, smallButton: true, icon: Icons.refresh),
                            ],)],),),
                    child: Expanded(
                      flex: 5,
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(),
                              MyInput(
                                controller: _emailController,
                                hintText: "Email",
                                multiValidator: MultiValidator([
                                  RequiredValidator(errorText: returnValidationError(ValidationError.isRequired)),
                                  EmailValidator(errorText: returnValidationError(ValidationError.invalidEmail))
                                ]),
                              ),
                              SizedBox(),
                              RoundedElevatedButton(child: Text(' Search '), onPressed: () async {
                                  if(_formKey.currentState.validate()) {
                                    await searchUserAction();
                                  }
                                }, alignment: Alignment.centerRight, smallButton: true, icon: Icons.search_rounded),
                            ],
                          )),
                    ),
                  ),
                ]))));
  }

  Future<void> updateUserAction() async {
    String name = _firstNameController.text.trim();
    String last = _lastNameController.text.trim();
    print(uid + ' : role = ' + roles[isSelected.indexOf(true)]);
    await _db.editUserData(uid,roles[isSelected.indexOf(true)],name,last);
    _showSnackBar(successfulUserUpdate);
  }

  Future<void> searchUserAction() async {
    isSelected = [false, false, false];
    String userEmail = _emailController.text.trim();
    print(userEmail);
    final result = await _db.getUserByEmail(userEmail);
    if(result != null){
      setState(() {
        isUserSearched = false;
        uid = result.uid;
        _firstNameController.text = result.firstName;
        _lastNameController.text = result.lastName;
        isSelected[roles.indexOf(result.role)] = true;
      });
    }
    else{
      _showSnackBar(couldNotFindUser);
    }
  }

  void _showSnackBar(String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(seconds: 2),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () { },
      ),
    ));
  }
}
