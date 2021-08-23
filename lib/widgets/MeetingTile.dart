import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuildMeetingTile extends StatelessWidget {
  const BuildMeetingTile({
    Key key,
    @required dynamic meeting,
    Function onTap,
    Icon icon
  }) : _meeting = meeting, _onTap = onTap, _icon = icon, super(key: key);
  final dynamic _meeting;
  final Function _onTap;
  final Icon _icon;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    DateTime date = _meeting.date.toDate();
    return
      Card(
        shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.primary),
    borderRadius: BorderRadius.circular(15)
    ),
    shadowColor: theme.colorScheme.primary,
    child:ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Title: ${_meeting.title}'),
          Text('${DateFormat('dd-MM-yyyy').format(date)}')
        ],
      ),
        dense: true,
        // subtitle: Text('Teacher: ${_meeting.teacherName} Date: ${DateFormat('dd-MM-yyyy HH:mm').format(date)}'),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Teacher: ${_meeting.teacherName}'),
          Text('${DateFormat('HH:mm').format(date)}'),
        ],
      ),
      trailing: _icon,
      onTap: _onTap
    ));
  }
}