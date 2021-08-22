import 'package:flutter/material.dart';

import '../SizeConfig.dart';

class RoundedText extends StatelessWidget {
  final String _text;
  final String _roundedSide;
  final int _screenPercentageHeight;
  final int _screenPercentageWidth;
  const RoundedText({Key key, @required String text, @required String roundedSide, @required int screenPercentageHeight, @required int screenPercentageWidth}) : _text = text, _roundedSide = roundedSide, _screenPercentageHeight = screenPercentageHeight, _screenPercentageWidth = screenPercentageWidth, super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    int textSize = 4;
    if(_text.length >= 18){
      textSize = 3;
    }
    return _roundedSide == 'right' ? Container(
      height: SizeConfig.safeBlockVertical * _screenPercentageHeight,
      width: SizeConfig.safeBlockHorizontal * _screenPercentageWidth,
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.horizontal(
            right: Radius.circular(45.0)
        ),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(112, 35, 238, 0.7),
              blurRadius: 5.0),
        ],
      ),
      padding: EdgeInsets.all(10.0),
      child: Center(child: Text(_text,style: TextStyle(fontSize: textSize * SizeConfig.safeBlockVertical, color: theme.colorScheme.primary))),
    ) : Container(
      height: SizeConfig.safeBlockVertical * _screenPercentageHeight,
      width: SizeConfig.safeBlockHorizontal * _screenPercentageWidth,
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.horizontal(
            left: Radius.circular(45.0)
        ),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(112, 35, 238, 0.7),
              blurRadius: 5.0),
        ],
      ),
      padding: EdgeInsets.all(10.0),
      child: Center(child: Text(_text,style: TextStyle(fontSize: textSize * SizeConfig.safeBlockVertical, color: theme.colorScheme.primary))),
    )
    ;
  }
}

