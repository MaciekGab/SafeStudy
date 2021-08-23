import 'package:flutter/material.dart';

class RoundedElevatedButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  final Alignment alignment;
  final double width;
  final double height;
  const RoundedElevatedButton({Key key,@required this.child,@required this.onPressed,@required this.alignment, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return
      Align(
          alignment: alignment,
          child: Padding(
          padding: EdgeInsets.only(right: 10,left: 10),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        textStyle: TextStyle(color: Colors.white),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      child: Container(
        width: width ?? null,
        height: height ?? null,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  theme.colorScheme.primaryVariant,
                  theme.colorScheme.primary,
                ])),
        padding: EdgeInsets.all(10.0),
        child: child,
      ),
    )
          )
      );
  }
}
