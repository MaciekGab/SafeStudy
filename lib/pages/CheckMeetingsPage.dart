import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_auth_with_rolebased_ui/models/MeetingDataModel.dart';
import 'package:test_auth_with_rolebased_ui/pages/MeetingDetailPage.dart';

class CheckMeetingsPage extends StatefulWidget {
  final String role;
  final String uid;
  const CheckMeetingsPage({Key key, @required this.role, @required this.uid})
      : super(key: key);

  @override
  _CheckMeetingsPageState createState() =>
      _CheckMeetingsPageState(role: role, uid: uid);
}

class _CheckMeetingsPageState extends State<CheckMeetingsPage> {
  List<MeetingDataModel> _data = [];
  final String role;
  final String uid;
  bool flag = false;

  _CheckMeetingsPageState({@required this.role, @required this.uid});

  @override
  void initState() {
    super.initState();
    if (role == 'admin')
      getMeetings().then((value) {
        setState(() {
          _data = value;
          flag = true;
        });
      });
    else
      getMeetingsForTeacher(uid).then((value) {
        setState(() {
          _data = value;
          flag = true;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // SearchBar(text: 'XD', onChanged: searchMeeting, hintText: 'Title or Teacher Name'),
            Expanded(
              child: Visibility(
                visible: flag,
                replacement: Center(child: CircularProgressIndicator()),
                child: ListView.separated(
                    itemCount: _data.length,
                    separatorBuilder: (context, index) => Divider(
                          color: theme.colorScheme.secondary,
                          thickness: 1,
                        ),
                    itemBuilder: (_, index) {
                      return BuildMeeting(_data[index]);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<MeetingDataModel>> getMeetings() async {
    List<MeetingDataModel> test = [];
    QuerySnapshot testing;
    await FirebaseFirestore.instance
        .collection('meetings')
        .get()
        .then((value) => testing = value);
    testing.docs.forEach((element) {
      test.add(MeetingDataModel.fromFirestore(element));
    });
    return test;
  }

  Future<List<MeetingDataModel>> getMeetingsForTeacher(String uid) async {
    List<MeetingDataModel> test = [];
    QuerySnapshot testing;
    await FirebaseFirestore.instance
        .collection('meetings')
        .where('teacherID', isEqualTo: uid)
        .get()
        .then((value) => testing = value);
    testing.docs.forEach((element) {
      test.add(MeetingDataModel.fromFirestore(element));
    });
    return test;
  }
}
// class SearchMeetings extends StatelessWidget {
//   const SearchMeetings({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class BuildMeeting extends StatelessWidget {
  const BuildMeeting(
    this.meeting, {
    Key key,
  }) : super(key: key);
  final MeetingDataModel meeting;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    DateTime date = meeting.date.toDate();
    return ListTile(
      title: Text('Title: ${meeting.title}'),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Teacher: ${meeting.teacherName}'),
          Text('Date: ${DateFormat('dd-MM-yyyy HH:mm').format(date)}'),
        ],
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.primary,
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MeetingDetailPage(meeting: meeting)));
      },
    );
  }
}

// Legacy code -> old version with future builder instead of Future with parsing QuerySnapshot to objet model

// class CheckMeetingsPage extends StatefulWidget {
//   final String role;
//   final String uid;
//   const CheckMeetingsPage({Key key, @required this.role, @required this.uid}) : super(key: key);
//
//   @override
//   _CheckMeetingsPageState createState() => _CheckMeetingsPageState(role: role,uid: uid);
// }
//
// class _CheckMeetingsPageState extends State<CheckMeetingsPage> {
//   List<MeetingDataModel> _data = [];
//   var _dataa;
//   final String role;
//   final String uid;
//   bool flag = false;
//
//   _CheckMeetingsPageState({ @required this.role, @required this.uid});
//
//   @override
//   void initState() {
//     super.initState();
//     if (role == 'admin')
//       _dataa = getMeetings();
//     else
//       _dataa = getMeetingsForTeacher(uid);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           children: [
//             Expanded(
//               child:
//               FutureBuilder(
//                 future: _dataa,
//                 builder: (_, snapshot) {
//                   if(snapshot.hasData){
//                     return ListView.separated(
//                         itemCount: snapshot.data.length,
//                         separatorBuilder: (context, index) =>
//                             Divider(
//                               color: theme.colorScheme.secondary, thickness: 1,),
//                         itemBuilder: (_, index) {
//                           return BuildMeeting(snapshot.data[index]);
//                         });
//                   }
//                   else if (snapshot.hasError) {
//                     return Text("Couldn't load data: ${snapshot.error}");
//                   }
//                   else{
//                     return Center(child: CircularProgressIndicator());
//                   }
//                 },),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getMeetings() async{
//     var querySnapshot =  await FirebaseFirestore.instance.collection('meetings').get();
//     return querySnapshot.docs;
//   }
//   Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getMeetingsForTeacher(String uid) async{
//     var querySnapshot =  await FirebaseFirestore.instance.collection('meetings').where('teacherID', isEqualTo: uid).get();
//     return querySnapshot.docs;
//   }
// }
//
// class BuildMeeting extends StatelessWidget {
//   const BuildMeeting(this.meeting, {
//     Key key,
//   }) : super(key: key);
//   final DocumentSnapshot meeting;
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     DateTime date = meeting['date'].toDate();
//     return ListTile(
//       title: Text('Title: ${meeting['title']}'),
//       subtitle: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text('Teacher: ${meeting['teacherName']}'),
//           Text('Date: ${DateFormat('dd-MM-yyyy HH:mm').format(date)}'),
//         ],
//       ),
//       trailing: Icon(Icons.chevron_right,color: theme.colorScheme.primary,),
//       onTap: () {
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => MeetingDetailPage(meeting: meeting)));
//       },
//     );
//   }
// }
