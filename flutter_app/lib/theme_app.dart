import 'package:flutter/material.dart';

ThemeData themeApp() {
  final corPrimaria = Color(0xFF12159F);
  final corPrimariaDark = Color(0xFF00024E);
  final corPrimariaLight = Color(0xFF3F42FF);
  final corTextLight = Color(0xFFFFFFFF);
  // final corTextDark = Color(0xFF000000);

  final appBarTema = AppBarTheme(
    color: corPrimariaDark,
    titleTextStyle: TextStyle(color: corTextLight, fontSize: 20),
    centerTitle: true,
  );

  final botaoTema = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(corPrimaria),
      foregroundColor: WidgetStateProperty.all(corTextLight),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
  );

  final campoTextoTema = InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: corPrimariaDark),
      borderRadius: BorderRadius.circular(20),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: corPrimariaLight, width: 2),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  final textoTema = TextTheme(
    titleLarge: TextStyle(
      color: corPrimariaDark,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: TextStyle(fontSize: 25, color: corTextLight),

  );

  return ThemeData(
    primaryColor: corPrimaria,
    primaryColorDark: corPrimariaDark,
    primaryColorLight: corPrimariaLight,
    appBarTheme: appBarTema,
    elevatedButtonTheme: botaoTema,
    inputDecorationTheme: campoTextoTema,
    textTheme: textoTema,
  );
}
