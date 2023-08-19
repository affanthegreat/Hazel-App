import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/logics/user_engine.dart';
import 'package:hazel_client/main.dart';
import 'package:hazel_client/widgets/HazelFieldHeading.dart';
import 'package:hazel_client/widgets/HazelFieldLabel.dart';
import 'package:hazel_client/widgets/HazelFocusedButton.dart';

class HazelSignIn extends StatefulWidget {
  const HazelSignIn({super.key});

  @override
  State<HazelSignIn> createState() => _HazelSignInState();
}

class _HazelSignInState extends State<HazelSignIn> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
      ),
      backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10,right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HazelFieldHeading(
                    text: "Welcome back! "),
                const HazelFieldLabel(text: 'We have missed you already.'),
                Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: isDarkTheme ? Colors.white : Colors.black,
                        width: 3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: usernameController,
                      style: GoogleFonts.inter(
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Your user name..',
                          hintStyle: GoogleFonts.inter(
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                            color: isDarkTheme
                                ? Colors.grey
                                : Colors.grey.shade700,
                          )),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 0, bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: isDarkTheme ? Colors.white : Colors.black,
                        width: 3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: passwordController,
                      style: GoogleFonts.inter(
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Your totally secret password..',
                          hintStyle: GoogleFonts.inter(
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                            color: isDarkTheme
                                ? Colors.grey
                                : Colors.grey.shade700,
                          )),
                    ),
                  ),
                ),
                InkWell(
                    onTap: () async {
                      if(usernameController.text.isEmpty){
                        var snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'Looks like your username is empty. Fill that in please.',
                            style: GoogleFonts.inter(
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                              color: Colors.white,
                            ),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if(passwordController.text.isEmpty){
                        var snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'Umm, Did you enter your password?',
                            style: GoogleFonts.inter(
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                              color: Colors.white,
                            ),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else{
                        var data = {
                          'user_name':usernameController.text,
                          'password': passwordController.text
                        };
                        var status = await UserEngine().login(data);
                        if(status){
                          var snackBar = SnackBar(
                            backgroundColor: CupertinoColors.activeGreen,
                            content: Text(
                              "Login Successful",
                              style: GoogleFonts.inter(
                                textStyle: Theme.of(context).textTheme.bodyMedium,
                                color: Colors.white,
                              ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.pushReplacementNamed(context, '/home');
                        } else{
                          var snackBar = SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              "Looks like this profile doesn't exist with us.",
                              style: GoogleFonts.inter(
                                textStyle: Theme.of(context).textTheme.bodyMedium,
                                color: Colors.white,
                              ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }

                      }
                    },
                    child: const HazelFocusedButton(text: "Let me in now."))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 5,left: 10,right: 10),
            alignment: Alignment.bottomCenter,
            child: Text(
              'In 2020, the average number of accounts per user will be 207',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                textStyle: Theme.of(context).textTheme.labelSmall,
                color: isDarkTheme ? Colors.grey : Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }
}
