import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/bloc/settings/settings_bloc.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/logics/UserProfileModel.dart';
import 'package:hazel_client/logics/user_engine.dart';
import 'package:hazel_client/main.dart';
import 'package:hazel_client/screens/sign_up/lets_get_started.dart';
import 'package:hazel_client/screens/sign_up/user_details_collection.dart';
import 'package:hazel_client/widgets/HazelFieldHeading.dart';
import 'package:hazel_client/widgets/HazelFieldLabel.dart';
import 'package:hazel_client/widgets/HazelMetricWidget.dart';
import 'package:hive/hive.dart';
import 'package:icons_plus/icons_plus.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  SettingsBloc settingsBloc = SettingsBloc();
  @override
  void initState() {
    // TODO: implement initState
    settingsBloc.add(SettingsPageInitialLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget settingsButton(String txt, Icon icon) {
      return Container(
        height: 60,
        margin: const EdgeInsets.only(top: 3),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: isDarkTheme ? Colors.grey.shade900.withOpacity(0.5) : Colors.grey.shade100),
        child: Row(
          children: [
            Container(margin: const EdgeInsets.only(right: 15, left: 10), child: icon),
            Text(txt,
                style: GoogleFonts.inter(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  color: isDarkTheme ? Colors.white : Colors.black,
                ))
          ],
        ),
      );
    }



      Widget userCard(UserProfileModel? obj) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(color: isDarkTheme ? Colors.grey.shade900.withOpacity(0.3) : Colors.grey.shade100, border: Border.all(color: isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 10, left: 10),
                child: Text(
                  "@" + obj!.userName.toString(),
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: HazelMetricWidget(label: "Followers", value: obj!.userFollowers.toString(), color: CupertinoColors.activeBlue)),
                    Expanded(child: HazelMetricWidget(label: "Level", value: obj!.userLevel.toString(), color: CupertinoColors.activeBlue)),
                    Expanded(child: HazelMetricWidget(label: "Exp points", value: obj!.userExperiencePoints.toString(), color: CupertinoColors.activeBlue))
                  ],
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDarkTheme? Colors.grey.shade900: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: InkWell(
                  onTap: (){
                    settingsBloc.add(SettingsPageUnblock(obj));
                  },
                  child: Center(
                    child: Text("Unblock",style: GoogleFonts.inter(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      fontWeight: FontWeight.bold,
                      color: isDarkTheme ? Colors.white : Colors.black,
                    )),
                  ),
                ),
              )
            ],
          ),
        );
      }

    Widget settingsHome(){
      return Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: ListView(
          children: [
            const HazelFieldHeading(text: 'Hazel Pro'),
            const HazelFieldLabel(text: "Ultimate additions for your content."),
            settingsButton(
                "Available Flares",
                Icon(
                  Icons.tag,
                  color: isDarkTheme ? Colors.pinkAccent.shade700 : Colors.pinkAccent,
                )),
            settingsButton(
                "Advertisements",
                Icon(
                  Icons.business,
                  color: isDarkTheme ? Colors.yellowAccent.shade700 : Colors.yellowAccent,
                )),
            settingsButton(
                "HazelCoins",
                Icon(
                  Icons.token,
                  color: isDarkTheme ? Colors.blueAccent.shade700 : Colors.blueAccent,
                )),
            settingsButton(
                "Promotions and Engagement",
                Icon(
                  Icons.trending_up_rounded,
                  color: isDarkTheme ? Colors.redAccent : Colors.redAccent,
                )),
            Container(margin: const EdgeInsets.only(top: 10), child: const HazelFieldHeading(text: 'Main Settings')),
            InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => HazelUserDetailsCollection(update: true)));
                },
                child: settingsButton(
                    "Update your details",
                    Icon(
                      Iconsax.user_tag,
                      color: isDarkTheme ? Colors.greenAccent.shade700 : Colors.greenAccent,
                    ))),
            InkWell(
              onTap: (){
                settingsBloc.bloockedPageNumber= 1;
                settingsBloc.blockedAccounts ={};
                settingsBloc.add(SettingsPageUShowBlockedAccounts());
              },
              child: settingsButton(
                  "See blocked profiles",
                  Icon(
                    Iconsax.user,
                    color: isDarkTheme ? Colors.redAccent : Colors.redAccent,
                  )),
            ),
            settingsButton(
                "Privacy settings",
                Icon(
                  Iconsax.security,
                  color: isDarkTheme ? Colors.blueAccent.shade700 : Colors.blueAccent,
                )),
            InkWell(
              onTap: () async {
                var logoutStatus = await UserEngine().logout();
                if (logoutStatus) {
                  sessionData = null;
                  storage.delete(key: 'auth_token');
                  storage.delete(key: 'token');
                  var userProfileBox = await Hive.openBox('user_profile');
                  userProfileBox.delete('user_data');
                  Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => const HazelLetsGetStarted()));
                } else {
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
              child: settingsButton(
                  "Sign out from device",
                  Icon(
                    Iconsax.logout,
                    color: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade300,
                  )),
            ),
            Container(
              margin: EdgeInsets.only(top: 20,bottom: 10),
              alignment: Alignment.center,
              child: Text(
                "This is still beta version of Hazel. We promise to add new features frequently and make Hazel more fun than ever.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  textStyle: Theme.of(context).textTheme.labelSmall,
                  color: CupertinoColors.systemGrey.darkColor,
                ),
              ),
            )
          ],
        ),
      );
    }

    var appBarText = "";
    return BlocConsumer<SettingsBloc, SettingsState>(
        bloc: settingsBloc,
        listener: (context, state) {

        },
        builder: (context, state) {
          print(state.runtimeType);

          if(state is LoadUserBlockedAccounts && state.listOfUsers.isEmpty) {
              return Center(
                child: Text("You haven't blocked anybody.",style: GoogleFonts.inter(
                  textStyle: Theme.of(context).textTheme.labelSmall,
                  color: CupertinoColors.systemGrey.darkColor,
                ),),
              );
          }
          if (state is LoadUserBlockedAccounts){
            return Scaffold(
              backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                appBar: AppBar(
                  backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: (){
                        settingsBloc.add(SettingsPageInitialLoad());
                      },
                    ),
                  title: Text(appBarText,style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ))),
              body: Container(
                margin: EdgeInsets.all(10),
                child: ListView.builder(
                    itemCount: state.listOfUsers.length,
                    itemBuilder: (context,index){
                      if(index ==0){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const HazelFieldHeading(text: "Accounts that you blocked"),
                            const HazelFieldLabel(text: "For unblocking someone if you have changed your mind."),
                            userCard(state.listOfUsers.elementAt(index)),
                          ],
                        );
                      }
                  return userCard(state.listOfUsers.elementAt(index));
                }),
              ),
            );
          }


          if(state is SettingsLoading){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(state is SettingsLoaded){
            return Scaffold(
                backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                appBar: AppBar(
                  toolbarHeight: 50,
                  backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                ),
                body: settingsHome());
          }
        return Container();
        },
    );
  }
}
