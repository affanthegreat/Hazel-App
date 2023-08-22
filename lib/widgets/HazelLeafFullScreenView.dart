import 'package:flutter/material.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/main.dart';


class HazelLeafFullScreenView extends StatefulWidget {
  const HazelLeafFullScreenView({super.key});

  @override
  State<HazelLeafFullScreenView> createState() => _HazelLeafFullScreenViewState();
}

class _HazelLeafFullScreenViewState extends State<HazelLeafFullScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
      ),

    );
  }
}
