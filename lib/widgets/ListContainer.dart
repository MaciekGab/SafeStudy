import 'package:flutter/material.dart';

class ListContainer extends StatelessWidget {
  const ListContainer({Key key,@required this.child}) : super(key: key);

  final Widget child;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.only(left:5.0, right: 5.0, top: 5.0),
        decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.primary,width: 2),
            borderRadius: BorderRadius.circular(15)
        ),
        child: child);
  }
}
