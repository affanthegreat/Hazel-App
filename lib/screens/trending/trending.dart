import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/main.dart';


class HazelTrending extends StatefulWidget {
  const HazelTrending({super.key});

  @override
  State<HazelTrending> createState() => _HazelTrendingState();
}

class _HazelTrendingState extends State<HazelTrending> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
      appBar: AppBar(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        title: Text("Trending",  style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          textStyle: Theme.of(context).textTheme.bodyMedium,
          color: isDarkTheme? Colors.white: Colors.black,
        )),

      ),
    );
  }
}
