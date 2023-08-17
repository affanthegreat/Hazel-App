import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class HazelMetricWidget extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const HazelMetricWidget({super.key, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 65,
        margin: EdgeInsets.all(3),
        padding: const EdgeInsets.all(7.5),
        decoration: BoxDecoration(
            color: color.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisAlignment:  MainAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(label, style: GoogleFonts.inter(
                  color: color,
                  textStyle:Theme.of(context).textTheme.labelMedium,
                ) ,)),

            Container(
                alignment: Alignment.center,
                child: Text(value, style: GoogleFonts.inter(
                  color: color,
                  fontWeight: FontWeight.bold,
                  textStyle:
                  Theme.of(context).textTheme.titleLarge,
                ) ,))
          ],
        ),
      ),
    );
  }
}
