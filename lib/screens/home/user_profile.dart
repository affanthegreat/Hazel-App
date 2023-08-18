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
import 'package:hazel_client/widgets/HazelFocusedButton.dart';
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
  final TextEditingController searchFieldController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    userProfileBloc.add(UserProfileOnBeginEvent(true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    Widget postCreationTextField(){
      return    Container(
        margin: const EdgeInsets.only(top: 0, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
              color: isDarkTheme
                  ? Colors.grey.shade900
                  : Colors.grey.shade200,
              width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: TextField(
            controller: searchFieldController,
            maxLength: 400,
            style: GoogleFonts.sourceSansPro(
              textStyle: Theme.of(context).textTheme.bodyLarge,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
            maxLines: null,
            decoration: InputDecoration(
                counterText: '',
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Iconsax.search_favorite_1,
                        size: 28,
                      ),
                      onPressed: () {
                        userProfileBloc.add(UserProfileSearchEvent(searchFieldController.text, 1));
                      },
                    ),
                  ],
                ),
                border: InputBorder.none,
                hintText: "Find your friends..",
                hintStyle: GoogleFonts.sourceSansPro(
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  color: isDarkTheme
                      ? Colors.grey
                      : Colors.grey.shade700,
                )),
          ),
        ),
      );
    }
    return  BlocConsumer<UserProfileBloc, UserProfileState>(
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
              print(state.runtimeType);

              if (state is  UserProfileSearchSuccessful){
                return Scaffold(
                  backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  appBar: AppBar(
                    toolbarHeight: 90,
                    leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
                      searchFieldController.clear();
                      userProfileBloc.add(UserProfileOnBeginEvent(true));
                    },),
                    title: postCreationTextField(),
                    backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  ),
                  body: state.listOfUsers.isEmpty ? Center(child:Text('No Users found.', style: GoogleFonts.inter(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      fontWeight: FontWeight.bold,
                      color:isDarkTheme? Colors.white: Colors.black
                  ),) ,):ListView.builder(
                      itemCount: state.listOfUsers.length,
                      itemBuilder: (context,index){
                          if(index == 0){
                            return Container(
                              margin: EdgeInsets.only(left: 10,right: 10),
                              child: Column(
                                children: [
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: HazelFieldLabel(text: "Found these profiles..")),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      color: isDarkTheme?Colors.grey.shade900.withOpacity(0.5): Colors.grey.shade100,
                                      border: Border.all(color: isDarkTheme? Colors.grey.shade900:Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(top: 10,left: 10),
                                          child: Text("@" + state.listOfUsers[index]!.userName.toString(), style: GoogleFonts.inter(
                                            textStyle: Theme.of(context).textTheme.bodyLarge,
                                            fontWeight: FontWeight.bold,
                                            color: isDarkTheme
                                                ? Colors.white
                                                : Colors.black,
                                          ),),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(child: HazelMetricWidget(label: "Followers", value:state.listOfUsers[index]!.userFollowers.toString() , color:CupertinoColors.activeBlue)),
                                              Expanded(child: HazelMetricWidget(label: "Level", value:state.listOfUsers[index]!.userLevel.toString() , color:CupertinoColors.activeBlue)),
                                              Expanded(child: HazelMetricWidget(label: "Exp points", value:state.listOfUsers[index]!.userExperiencePoints.toString() , color:CupertinoColors.activeBlue))

                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          margin: EdgeInsets.only(right: 10,bottom: 10,left: 10),
                                          decoration: BoxDecoration(
                                              color: CupertinoColors.activeBlue,
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child:InkWell(
                                            onTap: (){
                                              userProfileBloc.add(UserProfileVisitEvent(state.listOfUsers[index]));
                                            },
                                            child: Center(
                                              child:Text("Visit profile", style: GoogleFonts.inter(
                                                  textStyle: Theme.of(context).textTheme.bodyMedium,
                                                  fontWeight: FontWeight.bold,
                                                  color:Colors.white
                                              ),),
                                            ),
                                          ) ,

                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(left: 10,right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: isDarkTheme
                                      ? Colors.grey.shade900
                                      : Colors.grey.shade200,
                                  width: 3),
                            ),
                          );
                  })
                );
              }
              if (state is UserProfileLoading) {
                return Scaffold(
                  backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  appBar: AppBar(
                    toolbarHeight: 90,
                    title: postCreationTextField(),
                    backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                    actions: [
                      IconButton(onPressed: () {}, icon: Icon(Iconsax.safe_home)),
                      IconButton(onPressed: () {}, icon: Icon(Iconsax.edit_2))
                    ],
                  ),
                  body: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state is UserProfileErrorLoading) {
                return Scaffold(
                  backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  appBar: AppBar(
                    toolbarHeight: 90,
                    title: postCreationTextField(),
                    backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                    actions: [
                      IconButton(onPressed: () {}, icon: Icon(Iconsax.safe_home)),
                      IconButton(onPressed: () {}, icon: Icon(Iconsax.edit_2))
                    ],
                  ),
                  body: RefreshIndicator(
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
                  ),
                );
              }
              if(state is UserProfileVisit){
                return Scaffold(
                  backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  appBar: AppBar(
                    backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: (){
                        userProfileBloc.add(UserProfileOnBeginEvent(true));
                      },
                    ),
                  ),
                  body: Container(
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
                            child: Row(
                              children: [
                                HazelMetricWidget(
                                    label: "Total Leaves",
                                    value: (state.obj!.userPublicLeafCount! +
                                        state.obj!.userPrivateLeafCount!)
                                        .toString(),
                                    color: CupertinoColors.activeBlue),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {

                                    },
                                    child: HazelMetricWidget(
                                      label: "Following",
                                      value: (state.obj!.userFollowing).toString(),
                                      color: CupertinoColors.activeBlue,
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
                                        color: CupertinoColors.activeBlue),
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
                                          ? CupertinoColors.systemYellow
                                          : Colors.yellowAccent,
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    child: HazelMetricWidget(
                                        label: "Level",
                                        value: (state.obj!.userLevel!).toString(),
                                      color: isDarkTheme
                                          ? CupertinoColors.systemYellow
                                          : Colors.yellowAccent),
                                  ),
                                ],
                              ),
                              Container(
                                height: 50,
                                margin: EdgeInsets.only(top: 10,bottom: 10),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.activeBlue,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Center(
                                  child: Text("Send Follow request",style: GoogleFonts.inter(
                                    textStyle: Theme.of(context)
                                        .textTheme.bodyMedium,
                                    fontWeight: FontWeight.bold,
                                    color: !isDarkTheme
                                        ? hazelLogoColorLight
                                        : hazelLogoColor,
                                  )),
                                ),
                              )
                            ],
                          ),
                          Divider(
                              color: isDarkTheme? Colors.grey.shade800: Colors.grey.shade200
                          ),


                          Container(
                            height: 100,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (state is UserProfileSuccessfulLoading) {
                return Scaffold(
                  backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                  appBar: AppBar(
                    toolbarHeight: 90,
                    title: postCreationTextField(),
                    backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                    actions:  [
                      IconButton(onPressed: () {}, icon: Icon(Iconsax.safe_home)),
                      IconButton(onPressed: () {}, icon: Icon(Iconsax.edit_2))
                    ],
                  ),
                  body: Container(
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
                            child: Row(
                              children: [
                                HazelMetricWidget(
                                    label: "Total Leaves",
                                    value: (state.obj!.userPublicLeafCount! +
                                            state.obj!.userPrivateLeafCount!)
                                        .toString(),
                                    color: CupertinoColors.activeBlue),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {},
                                    child: HazelMetricWidget(
                                      label: "Following",
                                      value: (state.obj!.userFollowing).toString(),
                                      color: CupertinoColors.activeBlue,
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
                                        color: CupertinoColors.activeBlue),
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
                                          ? CupertinoColors.systemYellow
                                          : Colors.yellowAccent,
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    child: HazelMetricWidget(
                                        label: "Level",
                                        value: (state.obj!.userLevel!).toString(),
                                      color: isDarkTheme
                                          ? CupertinoColors.systemYellow
                                          : Colors.yellowAccent,),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: LinearPercentIndicator(
                                  lineHeight: 30.0,
                                  percent: state.obj!.userExperiencePoints! /
                                      state.obj!.experienceNeededForLevelUp(
                                          state.obj!.userExperiencePoints!),
                                  backgroundColor:
                                      Colors.grey.shade900.withOpacity(0.5),
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
                            color: isDarkTheme? Colors.grey.shade800: Colors.grey.shade200
                          ),


                          Container(
                            height: 100,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Container();
            });
  }
}
