import 'package:flutter/material.dart';
import 'package:flutter_app/theme_app.dart';
import 'package:flutter_app/viewmodel/gabarito_view_model.dart';
import 'package:flutter_app/views/home_page.dart';
import 'package:flutter_app/views/login_page.dart';
import 'package:provider/provider.dart';

class MyAppf extends StatelessWidget {
  const MyAppf({super.key});
// MyAppf é o nome da classe que representa o aplicativo Flutter, que utiliza o pacote MaterialApp para definir o tema, como faziamos no Main.dart
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GabaritoViewModel()),
      ],
      child: MaterialApp(
        title: ('App Flutter x Spring Boot'),
        debugShowCheckedModeBanner: false,
        theme: themeApp(),
        initialRoute: '/login',
        routes: {'/login': (_) => LoginPage(), 
        '/home': (_) => HomePage()},
      ),
    );
  }
}
