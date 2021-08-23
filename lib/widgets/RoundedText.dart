import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';


class RoundedText extends StatelessWidget {
  final String _text;
  final String _roundedSide;
  final double _width;
  final Alignment _alignment;
  const RoundedText({Key key, @required String text, @required String roundedSide,@required double width, @required Alignment alignment}) : _text = text, _roundedSide = roundedSide, _width = width, _alignment = alignment, super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    var isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    return Align(alignment: _alignment, child:
    Container(
      width: _width,
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: _roundedSide =='right' ? BorderRadius.horizontal(right: Radius.circular(45.0)) : BorderRadius.horizontal(left: Radius.circular(45.0)),
        boxShadow: [
          BoxShadow(
              color: theme.colorScheme.primary,
              spreadRadius: 3,
              blurRadius: 8.0
          ),
        ],
      ),
      padding: EdgeInsets.all(10.0),
      child: Center(child:
      // Text(_text,style: TextStyle(fontSize: isPortrait ? 0.04*size.height : 0.08*size.height, color: theme.colorScheme.onBackground))
        AutoSizeText('$_text',style: TextStyle(fontSize: isPortrait ? 0.04*size.height : 0.04*size.height),maxLines: 1,)
      ),
    )
    );
  }
}

