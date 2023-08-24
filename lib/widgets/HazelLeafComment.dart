import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/logics/CommentModels.dart';
import 'package:hazel_client/logics/leaf_engine.dart';
import 'package:hazel_client/main.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class HazelLeafComment extends StatefulWidget {
  final LeafComments comment;
  const HazelLeafComment({super.key, required this.comment});

  @override
  State<HazelLeafComment> createState() => _HazelLeafCommentState();
}

class _HazelLeafCommentState extends State<HazelLeafComment> {

  final TextEditingController replyController = TextEditingController();
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
                      var leaf_id = widget.comment.leafId;
                      var comment_string = replyController.text;
                      var parent_comment_id = widget.comment.commentId;
                      if(comment_string.isNotEmpty){
                        var data = {
                          'leaf_id' :leaf_id,
                          'comment_string': comment_string,
                          'parent_comment_id': parent_comment_id
                        };
                         var status = await leafEngineObj.sendSubComment(data);
                         print("SUB COMEMNT STATUS");
                         print(status);
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
            padding: EdgeInsets.only(left: 10, right: 10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("@" + widget.comment.commentedById!,
                    style: GoogleFonts.inter(
                      textStyle: Theme.of(context).textTheme.labelSmall,
                      color: isDarkTheme ? Colors.grey.shade300 : Colors.grey.shade400,
                    )),
                Text(dateTimeToWords(widget.comment.createdDate!),
                    style: GoogleFonts.inter(
                      textStyle: Theme.of(context).textTheme.labelMedium,
                      color: isDarkTheme ? Colors.grey.shade600 : Colors.grey.shade400,
                    )),
                Text(widget.comment.comment!,
                    style: GoogleFonts.sourceSansPro(
                      letterSpacing: -0.3,
                      fontSize: 18,
                      color: isDarkTheme ? Colors.white : Colors.black,
                      textStyle: Theme.of(context).textTheme.titleMedium,
                    )),
              ],
            ),
          ),

          AnimatedSwitcher(duration: Duration(milliseconds: 350), child:    textFieldVisible
              ? Row(
            children: [
              Expanded(child: textField()),
              IconButton(
                  onPressed: () {
                    setState(() {
                      textFieldVisible = !textFieldVisible;
                    });
                  },
                  icon: const Icon(Iconsax.message_add_1, size: 18, color: Colors.grey))
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      textFieldVisible = !textFieldVisible;
                    });
                  },
                  icon: const Icon(Iconsax.message_add_1, size: 18, color: Colors.grey))
            ],
          ),)

        ],
      ),
    );
  }
}
