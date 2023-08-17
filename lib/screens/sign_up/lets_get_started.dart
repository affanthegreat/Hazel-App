import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/main.dart';

class HazelLetsGetStarted extends StatelessWidget {
  const HazelLetsGetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? darkScaffoldColor: lightScaffoldColor,
      body: Stack(
        children: [
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "Hazel",
                  style: GoogleFonts.paytoneOne(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    letterSpacing: -1,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme? hazelLogoColorLight : hazelLogoColor,
                  ),
                  children: [
                    TextSpan(
                        text: ".\n",
                        style: GoogleFonts.paytoneOne(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          letterSpacing: -5,
                          fontWeight: FontWeight.bold,
                          color: hazelLogoDotColor,
                        )),
                    TextSpan(
                        text: "A True Social Network.",
                        style: GoogleFonts.paytoneOne(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                          height: 0.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        )),
                  ]),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          height: 60,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: isDarkTheme? Border.all(color: Colors.yellowAccent):
                              Border.all(color: Colors.black,width: 2),
                              color: Colors.yellowAccent),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/sign_up');
                            },
                            child: Center(
                              child: Text("Let's get started.",
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    letterSpacing: 0.2,
                                    height: 1,
                                    fontWeight: FontWeight.bold,
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )),
                            ),
                          )),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, bottom: 7.5),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          "DISCLAIMER: This is a alpha version of Hazel so this may have some bugs and glitches. Please let us know about these kinds of things so we could improve your experience. ",
                      style: GoogleFonts.inter(
                        color: isDarkTheme ? Colors.grey.shade500: Colors.grey.shade600,
                        height: 1.3,
                        textStyle: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
