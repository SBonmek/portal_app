import 'package:flutter/material.dart';
import 'package:portal_app/core/config/config.dart';

class AppTheme {
  static ThemeData of(context) {
    ThemeData theme = Theme.of(context);

    TextTheme textTheme = theme.textTheme.copyWith(
      // headline1
      displayLarge: theme.textTheme.displayLarge?.copyWith(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
      // headline2
      displayMedium: theme.textTheme.displayMedium?.copyWith(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
      // headline3
      displaySmall: theme.textTheme.displaySmall?.copyWith(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
      // headline4
      headlineMedium: theme.textTheme.headlineMedium?.copyWith(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
      // headline5
      headlineSmall: theme.textTheme.headlineSmall?.copyWith(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
      // headline6
      titleLarge: theme.textTheme.titleLarge?.copyWith(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
      // subtitle1
      titleMedium: theme.textTheme.titleMedium?.copyWith(
        color: AppColors.black,
      ),
      // subtitle2
      titleSmall: theme.textTheme.titleSmall?.copyWith(
        color: AppColors.black,
      ),
      // bodyText1
      bodyLarge: theme.textTheme.bodyLarge?.copyWith(
        color: AppColors.black,
      ),
      // bodyText2
      bodyMedium: theme.textTheme.bodyMedium?.copyWith(
        color: AppColors.black,
      ),
      // caption
      bodySmall: theme.textTheme.bodySmall?.copyWith(
        color: AppColors.black,
      ),
      // button
      labelLarge: theme.textTheme.labelLarge?.copyWith(
        color: AppColors.black,
      ),
      // overline
      labelSmall: theme.textTheme.labelSmall?.copyWith(
        color: AppColors.black,
      ),
    );

    AppBarTheme appBarTheme = theme.appBarTheme.copyWith(
      color: AppColors.primaryColor,
      iconTheme: IconThemeData(color: AppColors.white),
      titleTextStyle: textTheme.titleLarge!.copyWith(
        color: AppColors.white,
      ),
    );

    ButtonThemeData buttonTheme = theme.buttonTheme.copyWith(
      buttonColor: AppColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        iconColor: AppColors.white,
        textStyle: textTheme.titleMedium!.copyWith(color: AppColors.white),
      ),
    );

    CardTheme cardTheme = theme.cardTheme.copyWith(color: AppColors.white);

    return theme.copyWith(
      primaryColor: AppColors.primaryColor,
      appBarTheme: appBarTheme,
      scaffoldBackgroundColor: AppColors.backgroundGrey,
      dialogBackgroundColor: AppColors.background,
      dividerColor: AppColors.lightGray,
      elevatedButtonTheme: elevatedButtonTheme,
      buttonTheme: buttonTheme,
      textTheme: textTheme,
      cardTheme: cardTheme,
    );
  }
}
