import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:test_auth_with_rolebased_ui/services/DatabaseService.dart';
import 'package:test_auth_with_rolebased_ui/widgets/GradientAppBar.dart';
import 'package:test_auth_with_rolebased_ui/widgets/MyInput.dart';
import 'package:test_auth_with_rolebased_ui/widgets/RoundedElevatedButton.dart';
import 'package:test_auth_with_rolebased_ui/widgets/RoundedText.dart';

import '../Utils.dart';

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
  final db = DatabaseService();
  String email = '', firstName = '', lastName = '', role = '', uid = '';
  bool isUserSearched = true;
  List<bool> isSelected = [true, false, false];
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
                                    await updateUserAction();
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
                                    await searchUserAction();
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
    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(uid)
        .update({
      'role': roles[isSelected.indexOf(true)],
      'firstName': name,
      'lastName': last,
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("User updated!"),
      duration: Duration(seconds: 2),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () { },
      ),
    ));
  }

  Future<void> searchUserAction() async {
    String userEmail = _emailController.text.trim();
    print(userEmail);
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('profiles')
        .where('email', isEqualTo: userEmail)
        .get();
    if (querySnapshot.size > 0) {
      var oneSet = querySnapshot.docs[0];
      print(oneSet.data().toString());
      setState(() {
        isUserSearched = false;
        uid = querySnapshot.docs[0]['uid'];
        _firstNameController.text = querySnapshot.docs[0]['firstName'];
        _lastNameController.text = querySnapshot.docs[0]['lastName'];
        role = querySnapshot.docs[0]['role'];
        if (querySnapshot.docs[0]['role'] == 'admin') {
          isSelected = [true, false, false];
        } else if (querySnapshot.docs[0]['role'] == 'teacher') {
          isSelected = [false, true, false];
        } else {
          isSelected = [false, false, true];
        }
      });
    }
  }
}
