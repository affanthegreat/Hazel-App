import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/bloc/leaf/leaf_bloc.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/logics/LeafModel.dart';
import 'package:hazel_client/logics/UserProfileModel.dart';
import 'package:hazel_client/logics/leaf_engine.dart';
import 'package:hazel_client/main.dart';
import 'package:hazel_client/widgets/HazelLeafFullScreenView.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HazelLeafWidget extends StatefulWidget {
  final LeafModel? leaf_obj;
  final UserProfileModel? user_obj;
  const HazelLeafWidget({super.key, required this.leaf_obj, required this.user_obj});

  @override
  State<HazelLeafWidget> createState() => _HazelLeafWidgetState();
}

class _HazelLeafWidgetState extends State<HazelLeafWidget> {
  String numToEng(int num) {
    if (num >= 1000000) {
      return (num / 1000000).toStringAsFixed(1) + ' mil';
    } else if (num >= 1000) {
      return (num / 1000).toStringAsFixed(1) + 'k';
    } else {
      return num.toString();
    }
  }

  String numToEngDouble(double num) {
    if (num >= 1000000) {
      return (num / 1000000).toStringAsFixed(1) + ' mil';
    } else if (num >= 1000) {
      return (num / 1000).toStringAsFixed(1) + 'k';
    } else {
      return num.toString();
    }
  }

  String dateTimeToWords(String dateTimeStr) {
    var dateTime = DateTime.parse(dateTimeStr);
    var formatter = DateFormat('MMMM d, y h:mm a');
    return formatter.format(dateTime.toLocal());
  }

  LeafBloc leafBloc = LeafBloc();

  @override
  void initState() {
    // TODO: implement initState
    leafBloc.add(LeafLoadedEvent(widget.leaf_obj, widget.user_obj));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget textField() {
      return Container(
        margin: const EdgeInsets.only(top: 0, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: isDarkTheme ? Colors.grey.shade700 : Colors.grey, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 10,
          ),
          child: TextField(
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
                      icon: Icon(
                        Icons.search,
                        color: isDarkTheme ? Colors.white : Colors.black,
                        size: 24,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                border: InputBorder.none,
                hintText: "Find your friends..",
                hintStyle: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  color: isDarkTheme ? Colors.grey : Colors.grey.shade700,
                )),
          ),
        ),
      );
    }



    List<String> getAllHashtags(String text) {
      final regexp = RegExp(r'\#[a-zA-Z0-9]+\b()');

      List<String> hashtags = [];

      regexp.allMatches(text).forEach((element) {
        if (element.group(0) != null) {
          hashtags.add(element.group(0).toString());
        }
      });

      return hashtags;
    }

    List<String> getAllMentions(String text) {
      final regexp = RegExp(r'\@[a-zA-Z0-9]+\b()');

      List<String> mentions = [];

      regexp.allMatches(text).forEach((element) {
        if (element.group(0) != null) {
          mentions.add(element.group(0).toString());
        }
      });

      return mentions;
    }


    RichText buildHighlightedText(String text) {


      List<String> hashtags = getAllHashtags(text);
      List<String> mentions = getAllMentions(text);

      List<TextSpan> textSpans = [];

      text.split(" ").forEach((value) {
        if (hashtags.contains(value)) {
          textSpans.add(TextSpan(
            text: '$value ',
            style: GoogleFonts.sourceSansPro(
            letterSpacing: -0.5,
            fontSize: 21,
            color: CupertinoColors.activeBlue,
            textStyle: Theme.of(context).textTheme.bodyLarge,
          ),
          ));
        } else if (mentions.contains(value)) {
          textSpans.add(TextSpan(
            text: '$value ',
              style: GoogleFonts.sourceSansPro(
                letterSpacing: -0.5,
                fontSize: 21,
                color: CupertinoColors.systemYellow,
                textStyle: Theme.of(context).textTheme.bodyLarge,
              )
          ));
        } else {
          textSpans.add(TextSpan(text: '$value ' , style: GoogleFonts.sourceSansPro(
            letterSpacing: -0.5,
            fontSize: 21,
            color: isDarkTheme ? Colors.white : Colors.black,
            textStyle: Theme.of(context).textTheme.bodyLarge,
          )));
        }
      });

      return RichText(text: TextSpan(children: textSpans));
    }
    return BlocConsumer<LeafBloc, LeafState>(
      bloc: leafBloc,
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        print(state.runtimeType);
        if (state is LeafLoadingState) {
          return Container(
            margin: const EdgeInsets.only(top: 50),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if(state is LeafFullScreenState){
          print(state.map);
          print(state.currentUser);
          print(state.leaf);
          return HazelLeafFullScreenView(leafObj: state.leaf, userObj: state.currentUser, map: state.map);
        }
        if (state is LeafSuccessfulLoadState) {
          bool like_status = state.map['like']!;
          bool dislike_status = state.map['dislike']!;
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade300,
                  width: 1.5
                ),
                  bottom: BorderSide(
                      color: isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade300,
                      width: 1.5
                  )
              )
              //border: Border.all(color: isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade300, width: 1.5),
              //color: isDarkTheme ? Colors.grey.shade900.withOpacity(0.5) : Colors.grey.shade50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(dateTimeToWords(widget.leaf_obj!.createdDate!),
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.labelMedium,
                          fontWeight: FontWeight.bold,
                          color: isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade500,
                        )),
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: isDarkTheme ? Colors.grey.shade800 : Colors.grey.shade100),
                                color: widget.leaf_obj!.leafType == "public"
                                    ? isDarkTheme
                                    ? Colors.grey.shade900
                                    : Colors.grey.shade200
                                    : Colors.greenAccent),
                            child: Center(
                              child: Text(
                                widget.leaf_obj!.leafType.toString().toUpperCase(),
                                style: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.labelSmall,
                                  fontWeight: FontWeight.bold,
                                  color: widget.leaf_obj!.leafType == "public" ? (isDarkTheme? Colors.white: Colors.grey.shade500) : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          margin: EdgeInsets.only(left: 5,right: 5,bottom: 10),
                          child: IconButton(
                            onPressed: (){
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen:HazelLeafFullScreenView(leafObj: widget.leaf_obj, userObj: widget.user_obj!, map: state.map),
                                withNavBar: true, // OPTIONAL VALUE. True by default.
                                pageTransitionAnimation: PageTransitionAnimation.sizeUp,
                              );
                            },
                            icon: Icon(Icons.fullscreen_rounded,color: (isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400),),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "@" + widget.user_obj!.userName!,
                          style: GoogleFonts.inter(
                            textStyle: Theme.of(context).textTheme.labelLarge,
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade700,
                          )),
                    ]),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: buildHighlightedText(widget.leaf_obj!.textContent!),
                ),
                Divider(color: isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade300),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              var status = await leafEngineObj.checkLike(widget!.leaf_obj!);
                              print("LIKE STATUS");
                              print(status);
                              print(dislike_status);
                              if (dislike_status) {
                                var dislike_removal_status = await leafEngineObj.removeDisLikeLeaf(widget!.leaf_obj!);
                                widget!.leaf_obj!.dislikesCount = widget!.leaf_obj!.dislikesCount! - 1;

                                if (status && dislike_removal_status == -100) {
                                  leafBloc.add(LeafLikeRemoveEvent(widget.leaf_obj));
                                } else {
                                  leafBloc.add(LeafLikeEvent(widget.leaf_obj));
                                }
                              } else {
                                if (status) {
                                  leafBloc.add(LeafLikeRemoveEvent(widget.leaf_obj));
                                } else {
                                  print("it should be here");
                                  leafBloc.add(LeafLikeEvent(widget.leaf_obj));
                                }
                              }
                            },
                            icon: Icon(
                              Iconsax.heart,
                              size: 28,
                              color: !like_status ? (isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400) : Colors.redAccent,
                            )),
                        Text(numToEng(widget.leaf_obj!.likesCount!),
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.labelMedium,
                              fontWeight: FontWeight.bold,
                              color: isDarkTheme ? hazelLogoColorLight : hazelLogoColor,
                            ))
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              var status = await leafEngineObj.checkDisLike(widget!.leaf_obj!);
                              print("DISLIKE STATUS");
                              print(status);
                              print(like_status);
                              if (like_status) {
                                var like_removal_status = await leafEngineObj.removeLikeLeaf(widget!.leaf_obj!);
                                widget!.leaf_obj!.likesCount = widget!.leaf_obj!.likesCount! - 1;
                                if (status && like_removal_status == -100) {
                                  leafBloc.add(LeafDislikeRemoveEvent(widget.leaf_obj));
                                } else {
                                  leafBloc.add(LeafDislikeEvent(widget.leaf_obj));
                                }
                              } else {
                                if (status) {
                                  leafBloc.add(LeafDislikeRemoveEvent(widget.leaf_obj));
                                } else {
                                  leafBloc.add(LeafDislikeEvent(widget.leaf_obj));
                                }
                              }
                            },
                            icon: Icon(
                              Iconsax.heart_remove,
                              size: 28,
                              color: !dislike_status ? (isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400) : Colors.blue.shade800,
                            )),
                        Text(numToEng(widget.leaf_obj!.dislikesCount!),
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.labelMedium,
                              fontWeight: FontWeight.bold,
                              color: isDarkTheme ? hazelLogoColorLight : hazelLogoColor,
                            ))
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon:const Icon(
                              Iconsax.huobi_token_ht,
                              size: 28,
                              color: CupertinoColors.activeOrange,
                            )),
                        Text(numToEngDouble(double.parse(widget.leaf_obj!.experienceRating!)),
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.labelMedium,
                              fontWeight: FontWeight.bold,
                              color: isDarkTheme ? hazelLogoColorLight : hazelLogoColor,
                            ))
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Iconsax.activity,
                              size: 28,
                              color: CupertinoColors.systemYellow,
                            )),
                        Text(numToEng(widget.leaf_obj!.viewCount!),
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.labelMedium,
                              fontWeight: FontWeight.bold,
                              color: isDarkTheme ? hazelLogoColorLight : hazelLogoColor,
                            ))
                      ],
                    ),

                  ],
                ),

              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
