import 'package:dio/dio.dart';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:hazel_client/logics/UserProfileModel.dart';
import 'package:hazel_client/logics/leaf_engine.dart';
import 'package:hazel_client/logics/user_engine.dart';
import 'package:hazel_client/screens/home/home.dart';
import 'package:hazel_client/screens/sign_up/lets_get_started.dart';
import 'package:hazel_client/screens/sign_up/main_signup.dart';
import 'package:hazel_client/screens/sign_up/sign_in.dart';
import 'package:hazel_client/screens/sign_up/user_details_collection.dart';
import 'package:hazel_client/widgets/HazelLeafFullScreenView.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

bool isDarkTheme = true;

LeafEngine leafEngineObj = LeafEngine();
UserEngine userEngineObj = UserEngine();

Map<String, String>? sessionData;
void main()  async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  sessionData = await storage.readAll();
  Hive.registerAdapter(UserProfileModelAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hazel Client',
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme:
              AppBarTheme(iconTheme: IconThemeData(color: isDarkTheme? Colors.white: Colors.black))),
      initialRoute: (sessionData!['auth_token'] != null && sessionData!['token'] != null) ? '/home': '/' ,
      routes: {
        '/': (context) => const HazelLetsGetStarted(),
        '/sign_up': (context) => const SignUp(),
        '/sign_in': (context) => const HazelSignIn(),
        '/home': (context) => const HazelHome(),
        '/user_data': (context)=> HazelUserDetailsCollection(update: false),
      },
    );
  }
}
