import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/logics/user_engine.dart';
import 'package:hazel_client/main.dart';
import 'package:hazel_client/widgets/HazelFieldHeading.dart';
import 'package:hazel_client/widgets/HazelFieldLabel.dart';
import 'package:hazel_client/widgets/HazelFocusedButton.dart';
import 'package:hive/hive.dart';

class HazelUserDetailsCollection extends StatefulWidget {
  final bool update;



  HazelUserDetailsCollection({super.key, required this.update});

  @override
  State<HazelUserDetailsCollection> createState() => _HazelUserDetailsCollectionState();
}

class _HazelUserDetailsCollectionState extends State<HazelUserDetailsCollection> {
  final TextEditingController userFullName = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController countryCode = TextEditingController();

  final TextEditingController phoneNumber = TextEditingController();

  final TextEditingController address = TextEditingController();

  String gender = "male";


  updateData() async {

    var data =json.decode(await UserEngine().getUserDetails());
    setState(() {
      userFullName.text = data['user_full_name'];
      age.text = data['user_age'].toString();
      phoneNumber.text = data['user_phone_number'].toString();
      address.text = data['user_address'];
      gender = data['user_gender'];
    });

  }

  @override
  void initState() {
    if(widget.update){
      updateData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget textField(String txt, TextEditingController cntrl, TextInputType type) {
      return Container(
        margin: const EdgeInsets.only(top: 15, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isDarkTheme ? Colors.white : Colors.black, width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            keyboardType: type,
            style: GoogleFonts.inter(
              textStyle: Theme.of(context).textTheme.bodyMedium,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
            controller: cntrl,
            maxLines: null,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: txt,
                hintStyle: GoogleFonts.inter(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  color: isDarkTheme ? Colors.grey : Colors.grey.shade700,
                )),
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        appBar: AppBar(
          backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 5),
                alignment: Alignment.topLeft,
                child: HazelFieldHeading(text: widget.update ? "Update details" : "Before we start.."),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: HazelFieldLabel(text: widget.update ? "It's always a good thing to update." : "we need little bit of your information for some of our features to work."),
              ),
              Row(
                children: [
                  Expanded(child: textField("Your full name", userFullName, TextInputType.text)),
                  Container(
                      width: 80,
                      margin: EdgeInsets.only(left: 5),
                      child: textField("Age", age, TextInputType.number)),
                ],
              ),
              Row(
                children: [
                  Container(width: 80, margin: const EdgeInsets.only(right: 5), child: textField("91", countryCode, TextInputType.number)),
                  Expanded(child: textField("Phone number", phoneNumber, TextInputType.number)),
                ],
              ),
              textField("Address", address,TextInputType.text),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 5,top: 5),
                    child: ChoiceChip(
                      label: Text('Male'),
                      selectedColor: Colors.yellowAccent,
                      labelStyle: GoogleFonts.inter(
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme ? (gender == "male") ? Colors.black: Colors.white : (gender == "male")? Colors.black: Colors.black,
                      ),
                      backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                      selected: gender == "male",
                      onSelected: (bool selected) {
                        setState(() {
                          gender = "male";
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 5,top: 5),
                    child: ChoiceChip(
                      label: Text('Female'),
                      selectedColor: Colors.yellowAccent,
                      labelStyle: GoogleFonts.inter(
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme ? (gender == "female") ? Colors.black: Colors.white : (gender == "female")? Colors.black: Colors.black,
                      ),
                      backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                      selected: gender == "female",
                      onSelected: (bool selected) {
                        setState(() {
                          gender = "female";
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 5,top: 5),
                    child: ChoiceChip(
                      label: Text('Other'),
                      selectedColor: Colors.yellowAccent,
                      labelStyle: GoogleFonts.inter(
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme ? (gender == "other") ? Colors.black: Colors.white : (gender == "other")? Colors.black: Colors.black,
                      ),
                      backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
                      selected: gender == "other",
                      onSelected: (bool selected) {
                        setState(() {
                          gender = "other";
                        });
                      },
                    ),
                  ),
                ],
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: InkWell(
                      onTap: ()async {
                        if (userFullName.text.isEmpty) {
                          var snackBar = SnackBar(
                            backgroundColor: CupertinoColors.systemRed,
                            content: Text(
                              "Your name can't be empty.",
                              style: GoogleFonts.inter(
                                textStyle: Theme.of(context).textTheme.bodyMedium,
                                color: Colors.white,
                              ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                        if (age.text.isEmpty) {
                          var snackBar = SnackBar(
                            backgroundColor: CupertinoColors.systemRed,
                            content: Text(
                              "Looks like you didn't fill in your age",
                              style: GoogleFonts.inter(
                                textStyle: Theme.of(context).textTheme.bodyMedium,
                                color: Colors.white,
                              ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                        if (int.parse(age.text) <0) {
                          var snackBar = SnackBar(
                            backgroundColor: CupertinoColors.systemRed,
                            content: Text(
                              "Is that age even real? ",
                              style: GoogleFonts.inter(
                                textStyle: Theme.of(context).textTheme.bodyMedium,
                                color: Colors.white,
                              ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                        if (countryCode.text.isEmpty) {
                          var snackBar = SnackBar(
                            backgroundColor: CupertinoColors.systemRed,
                            content: Text(
                              "Country code for phone number can't be empty.",
                              style: GoogleFonts.inter(
                                textStyle: Theme.of(context).textTheme.bodyMedium,
                                color: Colors.white,
                              ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                        if (phoneNumber.text.isEmpty) {
                          var snackBar = SnackBar(
                            backgroundColor: CupertinoColors.systemRed,
                            content: Text(
                              "Phone number can't be empty.",
                              style: GoogleFonts.inter(
                                textStyle: Theme.of(context).textTheme.bodyMedium,
                                color: Colors.white,
                              ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                        if (address.text.isEmpty) {
                          var snackBar = SnackBar(
                            backgroundColor: CupertinoColors.systemRed,
                            content: Text(
                              "Address can't be empty.",
                              style: GoogleFonts.inter(
                                textStyle: Theme.of(context).textTheme.bodyMedium,
                                color: Colors.white,
                              ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                        if (address.text.length < 3) {
                          var snackBar = SnackBar(
                            backgroundColor: CupertinoColors.systemRed,
                            content: Text(
                              "Address looks short, are you sure it's the right address?",
                              style: GoogleFonts.inter(
                                textStyle: Theme.of(context).textTheme.bodyMedium,
                                color: Colors.white,
                              ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                        Map locationData = await UserEngine().fetchUserLocation();
                        var box = await Hive.openBox('logged-in-user');
                        var user_obj = box.get('user_obj');
                        var data = {
                          'user_id': user_obj.userId,
                          'user_full_name': userFullName.text,
                          'user_phone_number': countryCode.text + phoneNumber.text,
                          'user_address': address.text,
                          'user_gender': gender,
                          'user_city': locationData['city'],
                          'user_country': locationData['country'],
                          'user_state': locationData['regionName'],
                          'user_region': locationData['region'],
                          'user_age': age.text,
                        };
                        var update_status = json.decode(await UserEngine().updateUserDetails(data));
                        if(!widget.update && update_status['message'] == 100){
                          Navigator.pushReplacementNamed(context, '/home');
                        } else if(update_status['message'] == 100){
                          Navigator.pop(context);
                        }
                      },
                      child: const HazelFocusedButton(text: "Save"))),
              Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: Text(
                  "We collect location data of your device such as the city, state and country you're in for leaderboards and regional trending pages while you use hazel.gg. We believe transparency between you and us is the key for our success.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    textStyle: Theme.of(context).textTheme.labelSmall,
                    color: CupertinoColors.systemGrey.darkColor,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
