import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';

class HazelFocusedButton extends StatelessWidget {

  final String text;

  const HazelFocusedButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          border: isDarkTheme ? Border.all(color: Colors.yellowAccent) :
          Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(5),
          color: Colors.yellowAccent),
      child: Center(
        child: Text(text,
            style: GoogleFonts.inter(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              textStyle: Theme
                  .of(context)
                  .textTheme
                  .bodyLarge,
            )),
      ),
    );
  }
}
