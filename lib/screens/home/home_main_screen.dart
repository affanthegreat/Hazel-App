import 'package:flutter/material.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/main.dart';
import 'package:hazel_client/widgets/HazelLogoSmall.dart';

import '../../widgets/HazelCategoryHeading.dart';


class HazelMainScreen extends StatefulWidget {
  const HazelMainScreen({super.key});

  @override
  State<HazelMainScreen> createState() => _HazelMainScreenState();
}

class _HazelMainScreenState extends State<HazelMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
          automaticallyImplyLeading: false,
          title: const Align(
              alignment: Alignment.bottomRight,
              child: HazelLogoSmall()),

        ),
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        body: Container(
          margin: const EdgeInsets.only(left: 10,right: 10),
          child: ListView(
            children: const [
              HazelCategoryHeading(text: "Recently\nAdded Stories.")
            ],
          ),
        )
    );
  }
}
