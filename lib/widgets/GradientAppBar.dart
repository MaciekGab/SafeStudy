import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  GradientAppBar({Key key}) :this.preferredSize = Size.fromHeight(50.0), super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      centerTitle: true,
      title: Text("Safe Study"),
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  theme.colorScheme.primaryVariant,
                  theme.colorScheme.primary,
                ])),
      ),
    );
  }
}
