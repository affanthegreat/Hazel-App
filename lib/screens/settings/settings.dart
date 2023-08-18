import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/logics/user_engine.dart';
import 'package:hazel_client/main.dart';
import 'package:hazel_client/screens/sign_up/lets_get_started.dart';
import 'package:hazel_client/widgets/HazelFieldHeading.dart';
import 'package:hive/hive.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
      appBar: AppBar(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        toolbarHeight: 30,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 10,right: 10),
        child: Column(
          children: [
            const Align(
                alignment: Alignment.centerLeft,
                child: HazelFieldHeading(text: 'Main Settings')),
            InkWell(
              onTap: () async {
                sessionData = null;
                storage.delete(key: 'auth_token');
                storage.delete(key: 'token');
                var userProfileBox = await Hive.openBox('user_profile');
                userProfileBox.delete('user_data');
                Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => HazelLetsGetStarted()));

              },
              child: Container(
                height: 60,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isDarkTheme? Colors.grey.shade900.withOpacity(0.5): Colors.grey.shade200
                ),
                child: Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(right: 15,left: 10),
                        child: Icon(Iconsax.logout, color: CupertinoColors.activeGreen,)),
                    Text("Sign out from device.", style: GoogleFonts.inter(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      color: isDarkTheme? Colors.white: Colors.black,
                    ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
