import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/bloc/leaf/leaf_bloc.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/logics/CommentModels.dart';
import 'package:hazel_client/logics/UserProfileModel.dart';
import 'package:hazel_client/main.dart';
import 'package:hazel_client/screens/home/user_profile.dart';
import 'package:hazel_client/widgets/HazelFieldHeading.dart';
import 'package:hazel_client/widgets/HazelLeafFullScreenView.dart';
import 'package:hive/hive.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class HazelLeafComment extends StatefulWidget {
  final LeafComments comment;
  final UserProfileModel? obj;
  final UserProfileModel? currentLoggedInUser;
  const HazelLeafComment({super.key, required this.comment, required this.obj, required this.currentLoggedInUser});

  @override
  State<HazelLeafComment> createState() => _HazelLeafCommentState();
}

class _HazelLeafCommentState extends State<HazelLeafComment> {
  final TextEditingController replyController = TextEditingController();
  final LeafBloc localLeafBloc = LeafBloc();

  @override
  void initState() {
    localLeafBloc.add(LeafLoadComment(widget.comment, widget.obj, widget.currentLoggedInUser));
    super.initState();
  }

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

  bool textFieldVisible = false;
  @override
  Widget build(BuildContext context) {
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

    Map? vote_status;
    RichText buildHighlightedText(String text) {
      List<String> hashtags = getAllHashtags(text);
      List<String> mentions = getAllMentions(text);

      List<TextSpan> textSpans = [];

      text.split(" ").forEach((value) {
        if (hashtags.contains(value)) {
          textSpans.add(TextSpan(
            text: '$value ',
            style: GoogleFonts.inter(
              letterSpacing: 0,
              color: CupertinoColors.activeBlue,
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
          ));
        } else if (mentions.contains(value)) {
          textSpans.add(TextSpan(
              text: '$value ',
              style: GoogleFonts.inter(
                letterSpacing: 0,
                color: CupertinoColors.systemYellow,
                textStyle: Theme.of(context).textTheme.bodyLarge,
              )));
        } else {
          textSpans.add(TextSpan(
              text: '$value ',
              style: GoogleFonts.inter(
                letterSpacing: 0,
                color: isDarkTheme ? Colors.white : Colors.black,
                textStyle: Theme.of(context).textTheme.bodyLarge,
              )));
        }
      });

      return RichText(text: TextSpan(children: textSpans));
    }

    RichText buildHighlightedUserText(String userFullName, String userName) {
      return RichText(
          text: TextSpan(children: [
        TextSpan(
            text: userFullName,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: isDarkTheme ? Colors.white : Colors.black,
              textStyle: Theme.of(context).textTheme.titleMedium,
            )),
        TextSpan(
            text: " @" + userName,
            style: GoogleFonts.inter(
              color: isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade600,
              textStyle: Theme.of(context).textTheme.labelLarge,
            )),
      ]));
    }

    Widget textField() {
      return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: isDarkTheme ? Colors.grey.shade800 : Colors.grey, width: 2),
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
            controller: replyController,
            decoration: InputDecoration(
                counterText: '',
                suffixIcon: IconButton(
                  icon: const Icon(
                    Iconsax.send_1,
                    color: Colors.blue,
                  ),
                  onPressed: () async {
                    if (replyController.text.isNotEmpty) {
                      var data = {'leaf_id': widget.comment.leafId, 'parent_comment_id': widget.comment.commentId!, 'comment_string': replyController.text};
                      leafFullScreenBloc.add(LeafSubComment(data));
                    }
                  },
                ),
                prefixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Iconsax.message_add, color: Colors.grey.shade400)],
                ),
                border: InputBorder.none,
                hintText: "Reply to this thread..",
                hintStyle: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  color: isDarkTheme ? Colors.grey : Colors.grey.shade700,
                )),
          ),
        ),
      );
    }

    String selectedValue = 'Option 1';
    List<String> dropdownItems = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];

    Widget comment_body() {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(right: 10,bottom:5 ),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isDarkTheme ? Colors.grey.shade900.withOpacity(0.75) : Colors.grey.shade300, width: 2)),
          //color: isDarkTheme ? Colors.grey.shade900.withOpacity(0.3) : Colors.grey.shade50,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            userProfileBloc.leavesPage = 1;
                            userProfileBloc.leavesSet = {};
                            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => UserProfile(profileVisit: true, userObj: widget.obj!)));
                          },
                          child: buildHighlightedUserText(widget.obj!.userFullName!, widget.obj!.userName!)),
                      (widget.currentLoggedInUser!.userId! == widget.comment.commentedById!) ?PopupMenuButton<String>(
                        color: Colors.grey.shade900,
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.grey,
                        ), // Icon for the menu
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'Delete',
                            onTap: () {
                              leafFullScreenBloc.add(LeafDeleteComments(widget.comment.commentId!));
                            },
                            child: Row(
                              children: [
                                Icon(Icons.delete_rounded,color: isDarkTheme ? hazelLogoColorLight : hazelLogoColor,),
                                Text(
                                  "Delete",
                                  style: GoogleFonts.poppins(
                                    textStyle: Theme.of(context).textTheme.labelLarge,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkTheme ? hazelLogoColorLight : hazelLogoColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ):Container(),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Text(dateTimeToWords(widget.comment.createdDate!),
                        style: GoogleFonts.inter(
                          textStyle: Theme.of(context).textTheme.labelMedium,
                          color: isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400,
                        )),
                  ),
                  buildHighlightedText(widget.comment.comment!)
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: textFieldVisible
                  ? Row(
                      key: const ValueKey<int>(0),
                      children: [
                        Expanded(child: textField()),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                textFieldVisible = !textFieldVisible;
                              });
                            },
                            icon: const Icon(Iconsax.message_minus, size: 18, color: Colors.grey))
                      ],
                    )
                  : Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 250,
                        height: 40,
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          key: const ValueKey<int>(1),
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  print("++++++++++++");
                                  print(vote_status);
                                  if (vote_status!.isEmpty) {
                                    print("VOTE STATUS NULL");
                                    localLeafBloc.add(LeafCommentVote("upvote", widget.comment.commentId!, widget.comment));
                                  } else {
                                    if (vote_status!['vote_action'] == "upvote") {
                                      print("REMOVE VOTE");
                                      localLeafBloc.add(LeafRemoveVote(widget.comment.commentId!, widget.comment, vote_status!['vote_action']));
                                    } else {
                                      print("REMOVE AND VOTE");
                                      widget.comment.votes = widget.comment.votes! + 1;
                                      localLeafBloc.add(LeafCommentVote("upvote", widget.comment.commentId!, widget.comment));
                                    }
                                  }
                                },
                                icon: Icon(
                                  Iconsax.arrow_up,
                                  size: 24,
                                  color: (vote_status!.isEmpty)
                                      ? Colors.grey
                                      : (vote_status!['vote_action'] == 'upvote')
                                          ? CupertinoColors.activeBlue
                                          : Colors.grey,
                                )),
                            Text(numToEng(widget.comment.votes!),
                                style: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.labelLarge,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkTheme ? hazelLogoColorLight : hazelLogoColor,
                                )),
                            IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  if (vote_status!.isEmpty) {
                                    print("VOTE STATUS NULL");
                                    localLeafBloc.add(LeafCommentVote("downvote", widget.comment.commentId!, widget.comment));
                                  } else {
                                    if (vote_status!['vote_action'] == "downvote") {
                                      print("REMOVE VOTE");
                                      localLeafBloc.add(LeafRemoveVote(widget.comment.commentId!, widget.comment, vote_status!['vote_action']));
                                    } else {
                                      print("REMOVE AND VOTE");
                                      widget.comment.votes = widget.comment.votes! - 1;
                                      localLeafBloc.add(LeafCommentVote("downvote", widget.comment.commentId!, widget.comment));
                                    }
                                  }
                                },
                                icon: Icon(
                                  Iconsax.arrow_down_2,
                                  size: 24,
                                  color: (vote_status!.isEmpty)
                                      ? Colors.grey
                                      : (vote_status!['vote_action'] == 'downvote')
                                          ? CupertinoColors.systemRed
                                          : Colors.grey,
                                )),
                            IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  setState(() {
                                    textFieldVisible = !textFieldVisible;
                                  });
                                },
                                icon: const Icon(Icons.reply_rounded, size: 24, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
            )
          ],
        ),
      );
    }

    return BlocConsumer<LeafBloc, LeafState>(
      bloc: localLeafBloc,
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is LeafCommentLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is LeafCommentSuccess) {
          vote_status = state.vote_status;
          print(state.vote_status);
          return comment_body();
        }
        if (state is LeafCommentLoadError) {
          return Center(
              child: Text("Some error occured.",
                  style: GoogleFonts.inter(
                    textStyle: Theme.of(context).textTheme.labelMedium,
                    color: isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400,
                  )));
        }
        return Container();
      },
    );
  }
}
