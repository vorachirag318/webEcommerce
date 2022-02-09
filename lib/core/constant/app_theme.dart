import 'package:flutter/material.dart';
import 'package:producttask/core/constant/app_colors.dart';

import 'app_settings.dart';

class AppTheme {
  static final ThemeData defTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
    fontFamily: kAppFont,
    textTheme: const TextTheme(
      bodyText2: TextStyle(color: Colors.black, fontSize: 18),
    ),
  );
}
