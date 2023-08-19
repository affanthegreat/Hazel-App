import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';


class HazelFieldHeading extends StatelessWidget {
  final String text;
  const HazelFieldHeading({super.key,required this.text });

  @override
  Widget build(BuildContext context) {
    return  Text(text,
        textAlign: TextAlign.left,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: isDarkTheme? Colors.white: Colors.black,
          textStyle:
          Theme.of(context).textTheme.headlineSmall,
        ));
  }
}
