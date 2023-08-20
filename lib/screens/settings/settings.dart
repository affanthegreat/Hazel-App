import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/logics/user_engine.dart';
import 'package:hazel_client/main.dart';
import 'package:hazel_client/screens/sign_up/lets_get_started.dart';
import 'package:hazel_client/widgets/HazelFieldHeading.dart';
import 'package:hazel_client/widgets/HazelFieldLabel.dart';
import 'package:hive/hive.dart';
import 'package:icons_plus/icons_plus.dart';


class Settings extends StatelessWidget {
  const Settings({super.key});




  @override
  Widget build(BuildContext context) {

    Widget settingsButton(String txt, Icon icon){
      return Container(
        height: 60,
        margin: const EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isDarkTheme? Colors.grey.shade900.withOpacity(0.5): Colors.grey.shade100
        ),
        child: Row(
          children: [
            Container(
                margin: const EdgeInsets.only(right: 15,left: 10),
                child: icon),
            Text(txt, style: GoogleFonts.inter(
              textStyle: Theme.of(context).textTheme.bodyMedium,
              color: isDarkTheme? Colors.white: Colors.black,
            ))
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
      appBar: AppBar(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        toolbarHeight: 30,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10,right: 10),
        child: ListView(

          children: [
            const HazelFieldHeading(text: 'Hazel Pro'),
            settingsButton("Available Flares", Icon(Icons.tag,color: isDarkTheme ? Colors.pinkAccent.shade700:  Colors.pinkAccent,)),
            settingsButton("Advertisements", Icon(Icons.business,color: isDarkTheme ? Colors.yellowAccent.shade700 : Colors.yellowAccent,)),
            settingsButton("HazelCoins", Icon(Icons.token,color: isDarkTheme ? Colors.blueAccent.shade700 : Colors.blueAccent,)),
            settingsButton("Promotions and Engagement", Icon(Icons.trending_up_rounded,color: isDarkTheme ? Colors.redAccent : Colors.redAccent,)),
            Container(
                margin: const EdgeInsets.only(top: 10),
                child: const HazelFieldHeading(text: 'Main Settings')),
            settingsButton("Update your details", Icon(Iconsax.user_tag,color: isDarkTheme ? Colors.greenAccent.shade700 : Colors.greenAccent,)),
            settingsButton("See blocked profiles", Icon(Iconsax.user,color: isDarkTheme ? Colors.redAccent : Colors.redAccent,)),
            settingsButton("Privacy settings", Icon(Iconsax.security,color: isDarkTheme ? Colors.blueAccent.shade700 : Colors.blueAccent,)),
            InkWell(
              onTap: () async {
                var logoutStatus = await UserEngine().logout();
                if(logoutStatus){
                  sessionData = null;
                  storage.delete(key: 'auth_token');
                  storage.delete(key: 'token');
                  var userProfileBox = await Hive.openBox('user_profile');
                  userProfileBox.delete('user_data');
                  Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => const HazelLetsGetStarted()));
                } else {
                  print(logoutStatus);
                  var snackBar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      "Something has happened and logout request has failed. Please try again.",
                      style: GoogleFonts.inter(
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        color: Colors.white,
                      ),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }

              },
              child: settingsButton("Sign out from device", Icon(Iconsax.logout,color: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade300,)),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              child:  Text(
                "Thanks for using hazel.gg, We ensure you that new features will be added every month and rest assure, with your help we can influence social media in a good way. -Affan.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  textStyle: Theme.of(context).textTheme.labelSmall,
                  color: CupertinoColors.systemGrey.darkColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
