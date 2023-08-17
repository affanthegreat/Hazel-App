import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';


class HazelFieldLabel extends StatelessWidget {
  final String text;
  const HazelFieldLabel({super.key,required this.text });

  @override
  Widget build(BuildContext context) {
    return  Text(text,
        textAlign: TextAlign.left,
        style: GoogleFonts.inter(
          color: isDarkTheme? Colors.grey.shade400: Colors.grey.shade600,
          textStyle:
          Theme.of(context).textTheme.labelLarge,
        ));
  }
}
