import 'package:flutter/material.dart';

BoxDecoration buildBoxDecoration(ThemeData theme) {
  return BoxDecoration(
      gradient: LinearGradient(
          tileMode: TileMode.clamp,
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: [0.1,0.25,0.5],
          colors: [
            theme.colorScheme.primary,
// theme.colorScheme.secondary,
            theme.colorScheme.secondary,
            theme.colorScheme.background,
          ]
      )
  );
}
