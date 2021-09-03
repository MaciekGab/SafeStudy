import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_auth_with_rolebased_ui/models/MeetingDataModel.dart';
import 'package:test_auth_with_rolebased_ui/pages/MeetingDetailPage.dart';
import 'package:test_auth_with_rolebased_ui/services/DatabaseService.dart';
import 'package:test_auth_with_rolebased_ui/widgets/GradientAppBar.dart';
import 'package:test_auth_with_rolebased_ui/widgets/ListContainer.dart';
import 'package:test_auth_with_rolebased_ui/widgets/MeetingTile.dart';
import 'package:test_auth_with_rolebased_ui/widgets/SearchBar.dart';

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
  var _db = DatabaseService();
  List<MeetingDataModel> _data = [];
  List<MeetingDataModel> _dataToSearch = [];
  String query = '';
  final String role;
  final String uid;
  bool flag = false;

  _CheckMeetingsPageState({@required this.role, @required this.uid});

  @override
  void initState() {
    super.initState();
    if (role == 'admin')
      _db.getMeetings().then((value) {
        setState(() {
          _data = value;
          _dataToSearch = value;
          flag = true;
        });
      });
    else
      _db.getMeetingsForTeacher(uid).then((value) {
        setState(() {
          _data = value;
          _dataToSearch = value;
          flag = true;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: GradientAppBar(
          title: Text('Show Meetings'),
        ),
        body: Column(
          children: [
            SearchBar(
                hintText: 'Title or Name or Date(dd-mm-yyyy)',
                onChanged: _searchMeeting ),
            Expanded(
                child: Visibility(
                  visible: flag,
                  replacement: Center(child: CircularProgressIndicator()),
                  child: ListContainer(
                    child: ListView.builder(
                      // separatorBuilder: (context, index) => Divider(
                      //   color: theme.colorScheme.secondary,
                      // ),
                        itemCount: _data.length,
                        itemBuilder: (_, index) {
                          return BuildMeetingTile(meeting: _data[index],icon: Icon(
                              Icons.chevron_right,
                              color: theme.colorScheme.primary,
                            ), onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => MeetingDetailPage(meeting: _data[index])));
                            },
                          );
                        }),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _searchMeeting(String value) {
    final meetings = _dataToSearch.where((element) {
      final titleLower = element.title.toLowerCase();
      final teacherLower = element.teacherName.toLowerCase();
      DateTime dateTime = element.date.toDate();
      final date = DateFormat('dd-MM-yyyy').format(dateTime);
      final valueLower = value.toLowerCase();

      return titleLower.contains(valueLower) || teacherLower.contains(valueLower) || date.contains(valueLower);
    }).toList();

    setState(() {
      this._data = meetings;
    });
  }
}