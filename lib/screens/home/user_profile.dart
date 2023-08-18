import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
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
    userProfileBloc.add(UserProfileOnBeginEvent(true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Iconsax.safe_home)),
            IconButton(onPressed: () {}, icon: Icon(Iconsax.edit_2))
          ],
        ),
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        body: BlocConsumer<UserProfileBloc, UserProfileState>(
            bloc: userProfileBloc,
            listener: (context, state) {
              print(state.runtimeType);
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
              print(state.runtimeType);
              if (state is UserProfileLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is UserProfileErrorLoading) {
                return RefreshIndicator(
                  backgroundColor:
                      isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  onRefresh: () async {
                    userProfileBloc.add(UserProfileOnBeginEvent(true));
                  },
                  child: ListView(
                    children: [
                      Center(
                        child: Text("Something went wrong. Pull to retry.",
                            style: GoogleFonts.inter(
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                              color: Colors.red,
                            )),
                      ),
                    ],
                  ),
                );
              }
              if (state is UserProfileSuccessfulLoading) {
                return Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: RefreshIndicator(
                    backgroundColor:
                        isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                    onRefresh: () async {
                      userProfileBloc.add(UserProfileOnBeginEvent(true));
                    },
                    child: ListView(
                      children: [
                        RichText(
                          text: TextSpan(

                              children: [
                                TextSpan(
                                    text: "@" + state.obj!.userName!,
                                    style: GoogleFonts.paytoneOne(
                                      textStyle: Theme.of(context)
                                          .textTheme.headlineSmall,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkTheme
                                          ? hazelLogoColorLight
                                          : hazelLogoColor,
                                    )),
                              ]),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              HazelMetricWidget(
                                  label: "Total Leaves",
                                  value: (state.obj!.userPublicLeafCount! +
                                          state.obj!.userPrivateLeafCount!)
                                      .toString(),
                                  color: CupertinoColors.inactiveGray),
                              Expanded(
                                child: InkWell(
                                  onTap: () {},
                                  child: HazelMetricWidget(
                                    label: "Following",
                                    value: (state.obj!.userFollowing).toString(),
                                    color: CupertinoColors.inactiveGray,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {},
                                  child: HazelMetricWidget(
                                      label: "Followers",
                                      value:
                                          (state.obj!.userFollowers).toString(),
                                      color: CupertinoColors.inactiveGray),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: HazelMetricWidget(
                                    label: "Experience points",
                                    value: ((state.obj!.userExperiencePoints)!
                                            .toInt())
                                        .toString(),
                                    color: isDarkTheme
                                        ? CupertinoColors.inactiveGray
                                        : Colors.grey,
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  child: HazelMetricWidget(
                                      label: "Level",
                                      value: (state.obj!.userLevel!).toString(),
                                      color: isDarkTheme
                                          ? CupertinoColors.inactiveGray
                                          : Colors.grey),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              child: LinearPercentIndicator(
                                lineHeight: 40.0,
                                percent: state.obj!.userExperiencePoints! /
                                    state.obj!.experienceNeededForLevelUp(
                                        state.obj!.userExperiencePoints!),
                                backgroundColor:
                                    Colors.grey.shade900.withOpacity(0.3),
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
                                    color: isDarkTheme
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                // animateFromLastPercent: true,
                                linearGradient: const LinearGradient(
                                  colors: [
                                    CupertinoColors.activeBlue,
                                    CupertinoColors.systemYellow,
                                  ],
                                ),

                                // onAnimationEnd: (){print('progress...');},
                                // widgetIndicator: Icon(Icons.arrow_downward_outlined),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: isDarkTheme? Colors.yellowAccent: Colors.yellowAccent.shade700
                        ),
                   

                        Container(
                          height: 100,
                        )
                      ],
                    ),
                  ),
                );
              }
              return Container();
            }));
  }
}
