import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/bloc/leaf/leaf_bloc.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/logics/LeafModel.dart';
import 'package:hazel_client/logics/UserProfileModel.dart';
import 'package:hazel_client/main.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

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

  String dateTimeToWords(String dateTimeStr) {
    var dateTime = DateTime.parse(dateTimeStr);
    var formatter = DateFormat('MMMM d, y h:mm a');
    return formatter.format(dateTime.toLocal());
  }

  LeafBloc leafBloc = LeafBloc();

  @override
  void initState() {
    // TODO: implement initState
    leafBloc.add(LeafLoadedEvent(widget.leaf_obj));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeafBloc, LeafState>(
      bloc: leafBloc,
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        print(state.runtimeType);
        if (state is LeafLoadingState) {
          return Container(
            margin: EdgeInsets.only(top: 50),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is LeafSuccessfulLoadState) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              //border: Border.all(color: isDarkTheme? Colors.grey.shade900: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade300, width: 1.5),
              color: isDarkTheme ? Colors.grey.shade900.withOpacity(0.5) : Colors.grey.shade50,
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
                          color: isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade700,
                        )),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isDarkTheme ? Colors.grey.shade800 : Colors.grey.shade100),
                            color: widget.leaf_obj!.leafType == "public"
                                ? isDarkTheme
                                    ? Colors.grey.shade900
                                    : Colors.grey.shade800
                                : Colors.greenAccent),
                        child: Center(
                          child: Text(
                            widget.leaf_obj!.leafType.toString().toUpperCase(),
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.labelSmall,
                              fontWeight: FontWeight.bold,
                              color: widget.leaf_obj!.leafType == "public" ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "@" + widget.user_obj!.userName!,
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme ? Colors.grey.shade700 : Colors.grey.shade900,
                          )),
                    ]),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(widget.leaf_obj!.textContent!,
                      style: GoogleFonts.sourceSansPro(
                        letterSpacing: -0.5,
                        color: isDarkTheme ? Colors.white : Colors.black,
                        textStyle: Theme.of(context).textTheme.titleLarge,
                      )),
                ),
                Divider(color: isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade300),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              leafBloc.add(LeafLikeEvent(widget.leaf_obj));
                            },
                            icon: Icon(
                              Iconsax.heart,
                              size: 28,
                              color: Colors.redAccent,
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
                            onPressed: () {
                              leafBloc.add(LeafDislikeEvent(widget.leaf_obj));
                            },
                            icon: Icon(
                              Iconsax.heart_remove,
                              size: 28,
                              color: Colors.grey.shade800,
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
                            icon: Icon(
                              Iconsax.message,
                              size: 28,
                              color: !isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                            )),
                        Text(numToEng(widget.leaf_obj!.commentsCount!),
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
                Divider(color: isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade300),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
