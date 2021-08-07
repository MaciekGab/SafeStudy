import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_auth_with_rolebased_ui/services/DatabaseService.dart';

class ChangeUserRolePage extends StatefulWidget {

  @override
  _ChangeUserRolePageState createState() => _ChangeUserRolePageState();
}

class _ChangeUserRolePageState extends State<ChangeUserRolePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final db = DatabaseService();
  String email = '', firstName = '', lastName = '', role = '',uid = '';
  bool isUserSearched = false;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: SafeArea(
            child: Center(
                child: Column(children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "Email"),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        String userEmail = _emailController.text.trim();
                        print(userEmail);
                        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('profiles').where('email',isEqualTo: userEmail).get();
                        if(querySnapshot.size > 0) {
                          isUserSearched = true;
                          var oneSet = querySnapshot.docs[0];
                          print(oneSet.data().toString());
                          setState(() {
                            email = oneSet['email'];
                            uid = querySnapshot.docs[0]['uid'];
                            firstName = querySnapshot.docs[0]['firstName'];
                            lastName = querySnapshot.docs[0]['lastName'];
                            role = querySnapshot.docs[0]['role'];
                          });
                          print(email + ' ' + firstName + ' ' + lastName + ' ' +
                              role + '|' + uid);
                        }
                      },
                      child: Container(child: Text('SignIn'))),
                  Text(email),
                  SizedBox(height: 10),
                  Text(uid),
                  SizedBox(height: 10),
                  Text(firstName),
                  SizedBox(height: 10),
                  Text(lastName),
                  SizedBox(height: 10),
                  Text(role),
                  SizedBox(height: 20),
                  if(isUserSearched) ...{
                  TextFormField(
                    controller: _roleController,
                    decoration: InputDecoration(hintText: "New role"),
                  ),
                  ElevatedButton(
                      onPressed: () async{
                        String newRole = _roleController.text.trim();
                        print(uid + ' : role = ' + newRole);
                        FirebaseFirestore.instance.collection('profiles').doc(uid).update({
                          'role': _roleController.text.trim()
                        });
                  }, child: Text('Change role'))
                  }
                ]

                )

            )
        )
    );
  }
  Future<QuerySnapshot> getUserByEmail(String userEmail) async{
   return await FirebaseFirestore.instance.collection('profiles').where('email',isEqualTo: userEmail).get();
  }
}


