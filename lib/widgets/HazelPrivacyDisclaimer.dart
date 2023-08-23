import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/main.dart';


class HazelPrivacyDisclaimer extends StatelessWidget {
  const HazelPrivacyDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 7.5),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text:
              "By signing up with us, we will have your permission to collect data about few metrics for analytics and advertisement purposes. ",
              style: GoogleFonts.inter(
                height: 1.3,
                color: Colors.grey.shade600,
                textStyle: Theme.of(context).textTheme.labelSmall,
              ),
              children: [
                TextSpan(
                    text: "Check what we collect at ",
                    style: GoogleFonts.inter(
                      height: 1.3,
                      textStyle: Theme.of(context).textTheme.labelSmall,
                      color: Colors.grey.shade600,
                    )),
                TextSpan(
                    text: "analytics.hazel.gg",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => print('Tap Here onTap'),
                    style: GoogleFonts.inter(
                      height: 1.3,
                      textStyle: Theme.of(context).textTheme.labelSmall,
                      fontWeight: FontWeight.bold,
                      color: isDarkTheme ? Colors.blue : Colors.blue.shade400,
                    )),
              ]),
        ),
      ),
    );
  }
}
