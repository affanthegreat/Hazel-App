import 'package:flutter/material.dart';
import 'package:hazel_client/screens/sign_up/lets_get_started.dart';
import 'package:hazel_client/screens/sign_up/main_signup.dart';

bool isDarkTheme = true;


void main()  async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hazel Client',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme:
              AppBarTheme(iconTheme: IconThemeData(color: isDarkTheme? Colors.white: Colors.black))),
      initialRoute: '/',
      routes: {
        '/': (context) => const HazelLetsGetStarted(),
        '/sign_up': (context) => const SignUp(),
      },
    );
  }
}
