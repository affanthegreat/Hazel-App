import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/bloc/leaf/leaf_bloc.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/logics/CommentModels.dart';
import 'package:hazel_client/logics/LeafModel.dart';
import 'package:hazel_client/logics/UserProfileModel.dart';
import 'package:hazel_client/main.dart';
import 'package:hazel_client/widgets/HazelFieldHeading.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class HazelLeafFullScreenView extends StatefulWidget {
  final LeafModel? leafObj;
  final UserProfileModel userObj;
  final Map<String, dynamic> map;
  const HazelLeafFullScreenView({super.key, required this.leafObj, required this.userObj, required this.map});

  @override
  State<HazelLeafFullScreenView> createState() => _HazelLeafFullScreenViewState();
}

class _HazelLeafFullScreenViewState extends State<HazelLeafFullScreenView> {
  LeafBloc leafFullScreenBloc = LeafBloc();
  final ScrollController _scrollController = ScrollController();

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

  @override
  void initState() {
    leafFullScreenBloc.add(LeafFullScreenViewEvent(widget.leafObj, widget.userObj, widget.map));
    _scrollController.addListener(() {
    if (_scrollController.offset ==
    _scrollController.position.maxScrollExtent) {
    print("Hello world");
    }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController replyController = TextEditingController();
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
                    leafFullScreenBloc.add(LeafSendComment(replyController.text, widget.leafObj, widget.userObj, widget.map));
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

    void _addNode(TreeNode parent, String key, Map<dynamic, dynamic> children) {
      final newNode = TreeNode(key: key);
      if (children.isNotEmpty) {
        for (var entry in children.entries) {
          _addNode(newNode, entry.key, entry.value);
        }
      }
      parent.add(newNode);
    }

    TreeNode buildTree(Map<String, Map<dynamic, dynamic>> inputMap) {
      final rootNode = TreeNode(key: 'Root');
      for (var entry in inputMap.entries) {
        _addNode(rootNode, entry.key, entry.value);
      }
      return rootNode;
    }

    Widget leafMainSection() {
      return Container(
        margin: EdgeInsets.only(left: 10,right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dateTimeToWords(widget.leafObj!.createdDate!),
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.labelMedium,
                      fontWeight: FontWeight.bold,
                      color: isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400,
                    )),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 30,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isDarkTheme ? Colors.grey.shade800 : Colors.grey.shade100),
                        color: widget.leafObj!.leafType == "public"
                            ? isDarkTheme
                                ? Colors.grey.shade900
                                : Colors.grey.shade200
                            : Colors.greenAccent),
                    child: Center(
                      child: Text(
                        widget.leafObj!.leafType.toString().toUpperCase(),
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.labelSmall,
                          fontWeight: FontWeight.bold,
                          color: widget.leafObj!.leafType == "public" ? (isDarkTheme ? Colors.white : Colors.grey.shade500) : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "@" + widget.userObj!.userName!,
                      style: GoogleFonts.inter(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade700,
                      )),
                ]),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: Text(widget.leafObj!.textContent!,
                  style: GoogleFonts.sourceSansPro(
                    letterSpacing: -0.4,
                    color: isDarkTheme ? Colors.white : Colors.black,
                    fontSize: 22,
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                  )),
            ),
            Divider(color: isDarkTheme? Colors.grey.shade800:Colors.grey.shade400),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () async {},
                        icon: Icon(
                          Iconsax.heart,
                          size: 28,
                          color: !widget.map['like'] ? (isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400) : Colors.redAccent,
                        )),
                    Text(numToEng(widget.leafObj!.likesCount!),
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
                          var status = await leafEngineObj.checkDisLike(widget!.leafObj!);
                        },
                        icon: Icon(
                          Iconsax.heart_remove,
                          size: 28,
                          color: !widget.map['dislike'] ? (isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400) : Colors.blue.shade800,
                        )),
                    Text(numToEng(widget.leafObj!.dislikesCount!),
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
                          Iconsax.huobi_token_ht,
                          size: 28,
                          color: CupertinoColors.activeOrange,
                        )),
                    Text(numToEngDouble(double.parse(widget.leafObj!.experienceRating!)),
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
                    Text(numToEng(widget.leafObj!.viewCount!),
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.labelMedium,
                          fontWeight: FontWeight.bold,
                          color: isDarkTheme ? hazelLogoColorLight : hazelLogoColor,
                        ))
                  ],
                ),
              ],
            ),
            textField(),
          ],
        ),
      );
    }

    Widget commentCard(LeafComments comment) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade900, width: 1.5)),
          //color: isDarkTheme ? Colors.grey.shade900.withOpacity(0.3) : Colors.grey.shade50,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10,right: 10),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("@" + comment.commentedById!,
                      style: GoogleFonts.inter(
                        textStyle: Theme.of(context).textTheme.labelSmall,
                        color: isDarkTheme ? Colors.grey.shade300 : Colors.grey.shade400,
                      )),
                  Text(dateTimeToWords(comment.createdDate!),
                      style: GoogleFonts.inter(
                        textStyle: Theme.of(context).textTheme.labelMedium,
                        color: isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400,
                      )),
                  Text(comment.comment!,
                      style: GoogleFonts.sourceSansPro(
                        letterSpacing: -0.3,
                        fontSize: 18,
                        color: isDarkTheme ? Colors.white : Colors.black,
                        textStyle: Theme.of(context).textTheme.titleMedium,
                      )),

                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 5),
                child: Divider(
                  color: isDarkTheme ? Colors.grey.shade800 : Colors.grey.shade400,
                  thickness: 0.5,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Container(width: 24, height: 24, margin: EdgeInsets.only(left: 10, right: 10, bottom: 5), child: IconButton(onPressed: () {}, icon: const Icon(Iconsax.message_add_1, size: 18, color: Colors.grey)))],
            ),
          ],
        ),
      );
    }

    return Scaffold(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
          title: Text(
            "Thread",
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.bodyLarge,
              fontWeight: FontWeight.bold,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            leafFullScreenBloc.add(LeafFullScreenViewEvent(widget.leafObj, widget.userObj, widget.map));
          },
          child: BlocConsumer<LeafBloc, LeafState>(
              bloc: leafFullScreenBloc,
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is LeafSendingComment) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      Text("Saving your comment..",
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.labelMedium,
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme ? hazelLogoColorLight : hazelLogoColor,
                          ))
                    ],
                  );
                }
                if (state is LeafFullScreenState) {
                  return CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverList(
                          delegate: SliverChildListDelegate([
                        leafMainSection(),
                        Divider(color: isDarkTheme? Colors.grey.shade900:Colors.grey.shade200,),
                        Container(margin: EdgeInsets.only(top: 5, bottom: 10, left: 10, right: 10), child: HazelFieldHeading(text: "Replies")),
                      ])),
                      state.commentData.commentsTree.isEmpty
                          ? SliverToBoxAdapter(
                              child: SizedBox(
                                height: 100,
                                child: Center(
                                  child: Text("No comments found",
                                      style: GoogleFonts.inter(
                                        textStyle: Theme.of(context).textTheme.labelMedium,
                                        color: isDarkTheme ? hazelLogoColorLight : hazelLogoColor,
                                      )),
                                ),
                              ),
                            )
                          : SliverTreeView.simple(
                              tree: buildTree(state.commentData.commentsTree),
                              showRootNode: false,
                              indentation: const Indentation(style: IndentStyle.roundJoint, color: Colors.yellowAccent, thickness: 1.5, width: 30),
                              builder: (context, node) {
                                return commentCard(state.commentData.commentsMap[node.key]);
                              },
                            ),
                    ],
                  );
                }
                return Container();
              }),
        ));
  }
}
