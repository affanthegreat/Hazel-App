import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/bloc/home/home_bloc.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/main.dart';
import 'package:hazel_client/widgets/HazelLogoSmall.dart';
import 'package:icons_plus/icons_plus.dart';

class HazelMainScreen extends StatefulWidget {
  const HazelMainScreen({super.key});

  @override
  State<HazelMainScreen> createState() => _HazelMainScreenState();
}

class _HazelMainScreenState extends State<HazelMainScreen> {
  final TextEditingController contentController = TextEditingController();
  bool isPrivateLeafMode = true;

  HomeBloc homeBloc = HomeBloc();

  @override
  void initState() {
    homeBloc.add(HomeSuccessfullyLoadedEvent());
    super.initState();
  }

  createLeaf(String leafType) {
    homeBloc.add(HomeCreateLeafEvent(contentController.text, leafType));
    contentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    Widget postCreationTextField() {
      return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: isDarkTheme ? Colors.grey.shade700 : Colors.grey, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: TextField(
            controller: contentController,
            maxLength: 400,
            style: GoogleFonts.sourceSansPro(
              textStyle: Theme.of(context).textTheme.bodyLarge,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
            maxLines: null,
            decoration: InputDecoration(
                counterText: '',
                prefixIcon: const Icon(
                  Iconsax.additem,
                  size: 28,
                  color: CupertinoColors.systemGrey,
                ),
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Iconsax.attach_circle,
                        size: 28,
                        color: CupertinoColors.systemYellow,
                      ),
                      onPressed: () {
                        var snackBar = SnackBar(
                          backgroundColor: Colors.yellowAccent,
                          content: Text(
                            'Media support is coming soon. Please stay tuned.',
                            style: GoogleFonts.inter(
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                              color: Colors.black,
                            ),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                    GestureDetector(
                      onVerticalDragEnd: (e) {
                        setState(() {
                          isPrivateLeafMode = !isPrivateLeafMode;
                        });
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 550),
                        child: isPrivateLeafMode
                            ? IconButton(
                                icon: const Icon(
                                  Iconsax.send_2,
                                  color: CupertinoColors.systemYellow,
                                  size: 28,
                                ),
                                onPressed: () {
                                  createLeaf('public');
                                },
                              )
                            : IconButton(
                                icon: const Icon(
                                  Iconsax.send_2,
                                  color: CupertinoColors.activeGreen,
                                  size: 28,
                                ),
                                onPressed: () {
                                  createLeaf('private');
                                }),
                      ),
                    ),
                  ],
                ),
                border: InputBorder.none,
                hintText: "What you're up to..",
                hintStyle: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  color: isDarkTheme ? Colors.grey : Colors.grey.shade700,
                )),
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
          automaticallyImplyLeading: false,
          title: const HazelLogoSmall(),
        ),
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        body: BlocConsumer<HomeBloc, HomeState>(
          bloc: homeBloc,
          listener: (context, state) {
            if (state is HomeLeafCreationFailureState) {
              var snackBar = SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'Leaf Creation Failed. Try again later.',
                  style: GoogleFonts.inter(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    color: Colors.white,
                  ),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              homeBloc.add(HomeSuccessfullyLoadedEvent());
            }

            if (state is HomeLeafCreationSuccessfulState) {
              var snackBar = SnackBar(
                backgroundColor: CupertinoColors.activeGreen,
                content: Text(
                  'Leaf successfully created..',
                  style: GoogleFonts.inter(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    color: Colors.white,
                  ),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            if (state is HomeLeafInvalidMentions) {
              var snackBar = SnackBar(
                backgroundColor: CupertinoColors.systemRed,
                content: Text(
                  'User mentioned in the leaf does not exists.',
                  style: GoogleFonts.inter(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    color: Colors.white,
                  ),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              homeBloc.add(HomeSuccessfullyLoadedEvent());
            }

          },
          builder: (context, state) {
            if (state is HomeLeafCreationLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: CupertinoColors.systemYellow,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      "This may take a few moments..",
                      style: GoogleFonts.inter(
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        color: isDarkTheme ? Colors.grey : Colors.grey.shade700,
                      ),
                    ),
                  )
                ],
              );
            }
            if (state is HomeInitial || state is HomeSuccessfullyLoaded || state is HomeLeafCreationSuccessfulState) {
              return Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: ListView(
                  children: [
                    postCreationTextField(),
                  ],
                ),
              );
            }

            return Container();
          },
        ));
  }
}
