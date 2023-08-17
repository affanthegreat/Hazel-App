import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/bloc/user_profile/user_profile_bloc.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/main.dart';
import 'package:hazel_client/widgets/HazelCategoryHeading.dart';
import 'package:hazel_client/widgets/HazelFieldHeading.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:hazel_client/widgets/HazelLogoSmall.dart';
import 'package:hazel_client/widgets/HazelMetricWidget.dart';

import '../../widgets/HazelFieldLabel.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserProfileBloc userProfileBloc = UserProfileBloc();

  @override
  void initState() {
    // TODO: implement initState
    userProfileBloc.add(UserProfileOnBeginEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Iconsax.safe_home)),
            IconButton(onPressed: (){}, icon: Icon(Iconsax.edit_2))
          ],
        ),
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        body: BlocConsumer<UserProfileBloc, UserProfileState>(
            bloc: userProfileBloc,
            listener: (context, state) {
              if (state is UserProfileErrorLoading) {
                var snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    'Something went wrong. Please try again.',
                    style: GoogleFonts.inter(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      color: Colors.white,
                    ),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            builder: (context, state) {
              if (state is UserProfileSuccessfulLoading) {
                return Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: ListView(
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 3, bottom: 5),
                          child: HazelFieldHeading(
                              text: "Hey ${state.obj!.userName}!")),
                      Row(
                        children: [
                          HazelMetricWidget(
                              label: "Total Leaves",
                              value: (state.obj!.userPublicLeafCount! +
                                      state.obj!.userPrivateLeafCount!)
                                  .toString(),
                              color: CupertinoColors.activeBlue),
                          HazelMetricWidget(
                            label: "Following",
                            value: (state.obj!.userFollowing).toString(),
                            color: CupertinoColors.activeBlue,
                          ),
                          HazelMetricWidget(
                              label: "Followers",
                              value: (state.obj!.userFollowers).toString(),
                              color: CupertinoColors.activeBlue),
                        ],
                      ),
                      Column(
                        children: [

                          Row(
                            children: [
                              HazelMetricWidget(
                                  label: "Level",
                                  value: (state.obj!.userLevel!).toString(),
                                  color: isDarkTheme? CupertinoColors.systemYellow: Colors.grey),
                              HazelMetricWidget(
                                label: "Experience points",
                                value: ((state.obj!.userExperiencePoints)!
                                        .toInt())
                                    .toString(),
                                color: isDarkTheme? CupertinoColors.systemYellow: Colors.grey,
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10,bottom: 10),
                            child: LinearPercentIndicator(
                              lineHeight: 20.0,
                              percent:60/100,
                              backgroundColor: Colors.grey.shade900,
                              animation: true,
                              barRadius: Radius.circular(10),
                              alignment: MainAxisAlignment.center,
                              center: Text(
                                "${state.obj!.experienceNeededForLevelUp(state.obj!.userExperiencePoints!).toInt() - (state.obj!.userExperiencePoints)!.toInt()} points needed to level up.",
                                style: GoogleFonts.inter(
                                  textStyle:
                                      Theme.of(context).textTheme.labelSmall,
                                  color: Colors.white,
                                ),
                              ),
                              trailing: Text(
                                "${state.obj!.experienceNeededForLevelUp(state.obj!.userExperiencePoints!).toInt()}",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  textStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                  color: isDarkTheme? Colors.white: Colors.black,
                                ),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              // animateFromLastPercent: true,
                              linearGradient: const LinearGradient(
                                colors: [
                                  CupertinoColors.activeBlue,
                                  CupertinoColors.activeBlue,
                                ],
                              ),

                              // onAnimationEnd: (){print('progress...');},
                              // widgetIndicator: Icon(Icons.arrow_downward_outlined),
                            ),
                          ),
                        ],
                      ),
                      Divider(color: isDarkTheme? Colors.grey.shade900: Colors.grey.shade200,)
                    ],
                  ),
                );
              }
              return Container();
            }));
  }
}
