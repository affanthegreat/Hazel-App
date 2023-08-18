import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/main.dart';

class HazelLeaderboard extends StatefulWidget {
  const HazelLeaderboard({super.key});

  @override
  State<HazelLeaderboard> createState() => _HazelLeaderboardState();
}

class _HazelLeaderboardState extends State<HazelLeaderboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
      appBar: AppBar(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        title: Text("Leaderboard",  style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          textStyle: Theme.of(context).textTheme.bodyMedium,
          color: isDarkTheme? Colors.white: Colors.black,
        )),

      ),
    );
  }
}
