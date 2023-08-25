import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/bloc/user_profile/user_profile_bloc.dart';
import 'package:hazel_client/logics/CommentModels.dart';
import 'package:hazel_client/logics/UserProfileModel.dart';
import 'package:hazel_client/main.dart';
import 'package:hazel_client/screens/home/user_profile.dart';
import 'package:intl/intl.dart';

class HazelTopComment extends StatelessWidget {
  final LeafComments comment;
  final UserProfileModel? obj;

  const HazelTopComment({super.key, required this.comment, required this.obj});


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


  @override
  Widget build(BuildContext context) {
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
              textStyle: Theme
                  .of(context)
                  .textTheme
                  .bodyLarge,
            ),
          ));
        } else if (mentions.contains(value)) {
          textSpans.add(TextSpan(
              text: '$value ',
              style: GoogleFonts.inter(
                letterSpacing: 0,
                color: CupertinoColors.systemYellow,
                textStyle: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge,
              )));
        } else {
          textSpans.add(TextSpan(
              text: '$value ',
              style: GoogleFonts.inter(
                letterSpacing: 0,
                color: isDarkTheme ? Colors.white : Colors.black,
                textStyle: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge,
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
                  textStyle: Theme
                      .of(context)
                      .textTheme
                      .titleMedium,
                )),
            TextSpan(
                text: " @" + userName,
                style: GoogleFonts.inter(
                  color: isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade600,
                  textStyle: Theme
                      .of(context)
                      .textTheme
                      .labelLarge,
                )),
          ]));
    }


    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDarkTheme? Colors.grey.shade900.withOpacity(0.75): Colors.grey.shade200, width: 2)),
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
                InkWell(
                    onTap:(){
                      userProfileBloc.leavesPage = 1;
                      userProfileBloc.leavesSet = {};
                      userProfileBloc.add(UserProfileVisitEvent(obj!));
                    },
                    child: buildHighlightedUserText(obj!.userFullName!, obj!.userName!)),
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Text(dateTimeToWords(comment.createdDate!),
                      style: GoogleFonts.inter(
                        textStyle: Theme
                            .of(context)
                            .textTheme
                            .labelMedium,
                        color: isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400,
                      )),
                ),
                buildHighlightedText(comment.comment!)
              ],
            ),
          ),
        ],
      ),
    );
  }
}