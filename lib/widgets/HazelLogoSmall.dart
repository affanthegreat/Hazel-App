import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../main.dart';


class HazelLogoSmall extends StatelessWidget {
  const HazelLogoSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: "Hazel",
          style: GoogleFonts.paytoneOne(
            textStyle: Theme.of(context).textTheme.headlineSmall,
            letterSpacing: -1,
            fontWeight: FontWeight.bold,
            color: isDarkTheme? hazelLogoColorLight : hazelLogoColor,
          ),
          children: [
            TextSpan(
                text: ".",
                style: GoogleFonts.paytoneOne(
                  textStyle: Theme.of(context).textTheme.headlineSmall,
                  letterSpacing: -5,
                  fontWeight: FontWeight.bold,
                  color: hazelLogoDotColor,
                )),
          ]),
    );
  }
}
