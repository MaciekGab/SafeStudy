import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedElevatedButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  final Alignment alignment;
  final double width;
  final double height;
  final bool smallButton;
  final IconData icon;
  const RoundedElevatedButton({Key key,@required this.child,@required this.onPressed,@required this.alignment, this.width, this.height,@required this.smallButton,@required this.icon, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orientation = MediaQuery.of(context).orientation;
    final size = MediaQuery.of(context).size;
    return
      Align(
          alignment: alignment,
          child: Padding(
          padding: EdgeInsets.only(right: 10,left: 10),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        textStyle: orientation == Orientation.portrait ? TextStyle(color: Colors.white,fontFamily: GoogleFonts.exo2().fontFamily,
            fontSize: smallButton ? 0.02* size.height : 0.025*size.height
        ) : TextStyle(color: Colors.white,fontFamily: GoogleFonts.exo2().fontFamily,
        ),
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
        child: smallButton ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
            Icon(icon),
          ],
        ) : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.transparent),
            child,
            Icon(icon),
          ],
        ),
      ),
    )
          )
      );
  }
}