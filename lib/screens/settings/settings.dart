import 'package:flutter/material.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/main.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
    );
  }
}
