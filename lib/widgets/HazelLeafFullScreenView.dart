import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/bloc/leaf/leaf_bloc.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/logics/LeafModel.dart';
import 'package:hazel_client/logics/UserProfileModel.dart';
import 'package:hazel_client/logics/wrappers.dart';
import 'package:hazel_client/main.dart';
import 'package:hazel_client/widgets/HazelFieldHeading.dart';
import 'package:hazel_client/widgets/HazelLeafComment.dart';
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
  AutoScrollController _scrollController = AutoScrollController();

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
    super.initState();
  }
@override
  void dispose() {
    // TODO: implement dispose
  _scrollController.dispose();
    super.dispose();
  }
  var userObj;
  var leafObj;
  var map;
  var commentData;
  var like_status;
  var dislike_status;
  var showCommentField = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController replyController = TextEditingController();

    Widget textField() {
      return Container(
        key: const ValueKey<int>(2),
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
                hintText: "Your thoughts to this?",
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
              )
          ));
        } else {
          textSpans.add(TextSpan(text: '$value ' , style: GoogleFonts.poppins(
            letterSpacing: 0,
            color: isDarkTheme ? Colors.white : Colors.black,
            textStyle: Theme.of(context).textTheme.bodyLarge,
          )));
        }
      });

      return RichText(text: TextSpan(children: textSpans));
    }
    
    
    Widget leafMainSection() {
      return Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dateTimeToWords(leafObj!.createdDate!),
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
                        color: leafObj!.leafType == "public"
                            ? isDarkTheme
                                ? Colors.grey.shade900
                                : Colors.grey.shade200
                            : Colors.greenAccent),
                    child: Center(
                      child: Text(
                        leafObj!.leafType.toString().toUpperCase(),
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
                      text: "@" + userObj!.userName!,
                      style: GoogleFonts.inter(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme ? Colors.grey.shade400 : Colors.grey.shade700,
                      )),
                ]),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20,),
              child: buildHighlightedText(leafObj!.textContent)
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: isDarkTheme ? Colors.grey.shade900.withOpacity(0.5): Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                var status = await leafEngineObj.checkLike(leafObj!);
                                if (dislike_status) {
                                  var dislike_removal_status = await leafEngineObj.removeDisLikeLeaf(leafObj!);
                                  leafObj!.dislikesCount = leafObj!.dislikesCount! - 1;

                                  if (status && dislike_removal_status == -100) {
                                    leafFullScreenBloc.add(LeafLikeRemoveEvent(leafObj!));
                                  } else {
                                    leafFullScreenBloc.add(LeafLikeEvent(leafObj!));
                                  }
                                } else {
                                  if (status) {
                                    leafFullScreenBloc.add(LeafLikeRemoveEvent(leafObj!));
                                  } else {
                                    leafFullScreenBloc.add(LeafLikeEvent(leafObj!));
                                  }
                                }
                              },
                              icon: Icon(
                                Iconsax.heart,
                                size: 28,
                                color: !map['like'] ? (isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400) : Colors.redAccent,
                              )),
                          Text(numToEng(leafObj!.likesCount!),
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
                                var status = await leafEngineObj.checkDisLike(widget.leafObj!);

                                if (like_status) {
                                  var like_removal_status = await leafEngineObj.removeLikeLeaf(leafObj!);
                                  leafObj!.likesCount = leafObj!.likesCount! - 1;
                                  if (status && like_removal_status == -100) {
                                    leafFullScreenBloc.add(LeafDislikeRemoveEvent(leafObj!));
                                  } else {
                                    leafFullScreenBloc.add(LeafDislikeEvent(leafObj!));
                                  }
                                } else {
                                  if (status) {
                                    leafFullScreenBloc.add(LeafDislikeRemoveEvent(leafObj!));
                                  } else {
                                    leafFullScreenBloc.add(LeafDislikeEvent(leafObj!));
                                  }
                                }
                              },
                              icon: Icon(
                                Iconsax.heart_remove,
                                size: 28,
                                color: !map['dislike'] ? (isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400) : Colors.blue.shade800,
                              )),
                          Text(numToEng(leafObj!.dislikesCount!),
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
                          Text(numToEngDouble(double.parse(leafObj!.experienceRating!)),
                              style: GoogleFonts.poppins(
                                textStyle: Theme.of(context).textTheme.labelMedium,
                                fontWeight: FontWeight.bold,
                                color: isDarkTheme ? hazelLogoColorLight : hazelLogoColor,
                              ))
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Iconsax.activity,
                                  size: 28,
                                  color: CupertinoColors.systemYellow,
                                )),
                            Text(numToEng(leafObj!.viewCount!),
                                style: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.labelMedium,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkTheme ? hazelLogoColorLight : hazelLogoColor,
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(duration:const Duration(milliseconds: 250) ,child:!showCommentField ?textField(): Container( key: const ValueKey<int>(0),)),
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
            leafFullScreenBloc.commentsPage = 1;
            leafFullScreenBloc.commentData = CommentsRepo();
            leafFullScreenBloc.add(LeafFullScreenViewEvent(widget.leafObj, widget.userObj, widget.map));
          },
          child: BlocConsumer<LeafBloc, LeafState>(
              bloc: leafFullScreenBloc,
              listener: (context, state) {
                if (state is LeafSuccessfulLoadState) {
                  leafFullScreenBloc.add(LeafFullScreenViewEvent(widget.leafObj, widget.userObj, state.map));
                }
              },
              builder: (context, state) {
                if (state is LeafSendingComment) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text("Saving your comment..",
                              style: GoogleFonts.poppins(
                                textStyle: Theme.of(context).textTheme.labelMedium,
                                fontWeight: FontWeight.bold,
                                color: isDarkTheme ? hazelLogoColorLight : hazelLogoColor,
                              )),
                        )
                      ],
                    ),
                  );
                }
                if (state is LeafFullScreenState) {
                  leafObj = state.leaf;
                  userObj = state.currentUser;
                  map = state.map;
                  commentData = state.commentData;
                  like_status = state.map['like']!;
                  dislike_status = state.map['dislike']!;

                  var tree = buildTree(state.commentData.commentsTree);
                  return CustomScrollView(
                    shrinkWrap: true,
                    controller: _scrollController
                      ..addListener(() {
                        if (_scrollController.offset == _scrollController.position.maxScrollExtent) {
                          leafFullScreenBloc.add(LeafFullScreenViewEvent(widget.leafObj, widget.userObj, widget.map));
                        }
                      }),
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      SliverList(
                          delegate: SliverChildListDelegate([
                        leafMainSection(),
                        Divider(
                          color: isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade200,
                          thickness: 3.5,
                        ),
                        Container(margin: const EdgeInsets.only(top: 5, bottom: 10, left: 10, right: 10), child: const HazelFieldHeading(text: "Replies")),
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
                              tree: tree,
                              showRootNode: false,
                              scrollController: _scrollController,
                              expansionBehavior: ExpansionBehavior.collapseOthersAndSnapToTop,
                              expansionIndicatorBuilder: (context, node) => ChevronIndicator.rightDown(
                                tree: node,
                                color: Colors.yellowAccent,
                                padding: const EdgeInsets.all(8),
                              ),
                              indentation: const Indentation(style: IndentStyle.scopingLine, color: Colors.yellowAccent, thickness: 2, width: 30),
                              builder: (context, node) {
                                return HazelLeafComment(comment: state.commentData.commentsMap[node.key]);
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
