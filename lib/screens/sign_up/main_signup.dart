import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hazel_client/bloc/sign_up_bloc.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hazel_client/logics/user_engine.dart';
import 'package:hazel_client/main.dart';
import 'package:email_validator/email_validator.dart';
import 'package:hazel_client/widgets/HazelFieldHeading.dart';
import 'package:hazel_client/widgets/HazelFieldLabel.dart';
import 'package:hazel_client/widgets/HazelFocusedButton.dart';
import 'package:hazel_client/widgets/HazelPrivacyDisclaimer.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController userPassword1Controller = TextEditingController();
  final TextEditingController userPassword2Controller = TextEditingController();
  final SignUpBloc signUpBloc = SignUpBloc();

  @override
  void initState() {
    // TODO: implement initState
   signUpBloc.add(SignUpStartEvent());
    super.initState();
  }

  onSignUpClick() async {
   if (emailController.text.isNotEmpty &&
        EmailValidator.validate(emailController.text)) {
      var user_exists = (await  UserEngine().checkUserExists({'user_email':emailController.text}));
     if(!user_exists){
       var snackBar = SnackBar(
         backgroundColor: Colors.red,
         content: Text(
           'Looks like this email has been already registered with us.',
           style: GoogleFonts.inter(
             textStyle: Theme.of(context).textTheme.bodyMedium,
             color: Colors.white,
           ),
         ),
       );
       ScaffoldMessenger.of(context).showSnackBar(snackBar);
     } else {
       signUpBloc.add(SignUpEmailAddedEvent(emailController.text));
     }
    } else {
      var snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'We need your email in order to proceed.',
          style: GoogleFonts.inter(
            textStyle: Theme.of(context).textTheme.bodyMedium,
            color: Colors.white,
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget signUpEmail() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Scaffold(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        appBar: AppBar(
          backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        ),
        body: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HazelFieldHeading(
                      text: "Let's make you an account first."),
                  const HazelFieldLabel(text: '"Never gonna give you up."'),
                  Container(
                    margin: const EdgeInsets.only(top: 15, bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: isDarkTheme ? Colors.white : Colors.black,
                          width: 3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: emailController,
                        style: GoogleFonts.inter(
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                          color: isDarkTheme ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Your Email..',
                            hintStyle: GoogleFonts.inter(
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                              color: isDarkTheme
                                  ? Colors.grey
                                  : Colors.grey.shade700,
                            )),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                            onTap: onSignUpClick,
                            child: const HazelFocusedButton(text: "Let's Go!")),
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                  text: "Already have an account?\n",
                                  style: GoogleFonts.inter(
                                    color: isDarkTheme
                                        ? Colors.grey
                                        : Colors.grey.shade700,
                                    height: 1,
                                    textStyle:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: "Sign-in from here.",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap =
                                              () => Navigator.pushNamed(context, '/sign_in'),
                                        style: GoogleFonts.inter(
                                          height: 1,
                                          fontWeight: FontWeight.bold,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                          color: isDarkTheme
                                              ? Colors.blue
                                              : Colors.blue.shade400,
                                        )),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const HazelPrivacyDisclaimer()
            ],
          ),
        ),
      ),
    );
  }

  Widget signUpEmailAdded() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        leading: IconButton(
          onPressed: () {
            signUpBloc.add(SignUpStartEvent());
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                const StepProgressIndicator(
                  totalSteps: 4,
                  currentStep: 1,
                  selectedColor: Colors.pinkAccent,
                  unselectedColor: Colors.grey,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  alignment: Alignment.topLeft,
                  child: const HazelFieldHeading(
                      text: "What should you be called?"),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child:
                      const HazelFieldLabel(text: "choose wisely, you must."),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: isDarkTheme ? Colors.white : Colors.black,
                        width: 3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: usernameController,
                      style: GoogleFonts.inter(
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Your username..',
                          hintStyle: GoogleFonts.inter(
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                            color: isDarkTheme
                                ? Colors.grey
                                : Colors.grey.shade700,
                          )),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  child: InkWell(
                    onTap: () async {
                      if (usernameController.text.isNotEmpty) {
                        var status = await UserEngine().checkUserExists(
                            {'user_name': usernameController.text});


                        if(!status){
                          var snackBar = SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'User name might have been already taken. Think something new.',
                              style: GoogleFonts.inter(
                                textStyle: Theme.of(context).textTheme.bodyMedium,
                                color: Colors.white,
                              ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }else{
                          signUpBloc
                              .add(SignUpUserNameEvent(usernameController.text));
                        }

                      } else {
                        var snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "Looks like you didn't choose your name. ",
                            style: GoogleFonts.inter(
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                              color: Colors.white,
                            ),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: const HazelFocusedButton(
                        text: "This is what I wanna be called."),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            alignment: Alignment.bottomCenter,
            child: Text(
              "TRIVIA 101: People who keep weird usernames are always smart.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                textStyle: Theme.of(context).textTheme.labelSmall,
                color: isDarkTheme ? Colors.grey : Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget signUpUserNameAdded() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            signUpBloc.add(SignUpEmailAddedEvent(emailController.text));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
      ),
      backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                const StepProgressIndicator(
                  totalSteps: 4,
                  currentStep: 2,
                  selectedColor: Colors.pinkAccent,
                  unselectedColor: Colors.grey,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 5),
                  alignment: Alignment.topLeft,
                  child: HazelFieldHeading(
                      text:
                          "Okay ${usernameController.text}, Lets set your secret password."),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: const HazelFieldLabel(
                      text:
                          "Only you can see what your password is, not even us."),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: isDarkTheme ? Colors.white : Colors.black,
                        width: 3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: userPassword1Controller,
                      style: GoogleFonts.inter(
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Your Magic word..',
                          hintStyle: GoogleFonts.inter(
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                            color: isDarkTheme
                                ? Colors.grey
                                : Colors.grey.shade700,
                          )),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  child: InkWell(
                    onTap: () async {
                      if (userPassword1Controller.text.isNotEmpty &&
                          await UserEngine().validateStructure(
                              userPassword1Controller.text)) {
                        signUpBloc.add(SignUpPasswordCheck1Event(
                            userPassword1Controller.text));
                      } else {
                        var snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'Password does not look strong enough. Beef it up a little, Would ya?',
                            style: GoogleFonts.inter(
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                              color: Colors.white,
                            ),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child:
                        const HazelFocusedButton(text: "I'm good with this."),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            alignment: Alignment.bottomCenter,
            child: Text(
              'TRIVIA 101: Most common password people often use is "password" itself. Don\'t be that person.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                textStyle: Theme.of(context).textTheme.labelSmall,
                color: isDarkTheme ? Colors.grey : Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget signUpPasswordCheckAgain() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
        leading: IconButton(
          onPressed: () {
            signUpBloc.add(SignUpUserNameEvent(usernameController.text));
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor,
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                const StepProgressIndicator(
                  totalSteps: 4,
                  currentStep: 3,
                  selectedColor: Colors.pinkAccent,
                  unselectedColor: Colors.grey,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 5),
                  alignment: Alignment.topLeft,
                  child: const HazelFieldHeading(text: "Let's do it again."),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child:
                      const HazelFieldLabel(text: "Just to be sure about it."),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: isDarkTheme ? Colors.white : Colors.black,
                        width: 3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: userPassword2Controller,
                      style: GoogleFonts.inter(
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        color: isDarkTheme ? Colors.white : Colors.black,
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Your Magic word..',
                          hintStyle: GoogleFonts.inter(
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                            color: isDarkTheme
                                ? Colors.grey
                                : Colors.grey.shade700,
                          )),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  child: InkWell(
                    onTap: () {
                      if (userPassword1Controller.text ==
                          userPassword2Controller.text) {
                        signUpBloc.add(SignUpDataCollectedEvent(userPassword2Controller.text, emailController.text, usernameController.text));
                      } else {
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
                    child:
                        const HazelFocusedButton(text: "I'm good with this."),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            alignment: Alignment.bottomCenter,
            child: Text(
              'Another most common password used is 123456789.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                textStyle: Theme.of(context).textTheme.labelSmall,
                color: isDarkTheme ? Colors.grey : Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      bloc: signUpBloc,
      listener: (context, state)async {

        if(state is SignupAccountCreationSuccessful){
          var data = {
            'user_name':usernameController.text,
            'password': userPassword2Controller.text
          };
          var status = await UserEngine().login(data);
          if(status== "true"){
            var snackBar = SnackBar(
              backgroundColor: CupertinoColors.activeGreen,
              content: Text(
                "Account successfully created.",
                style: GoogleFonts.inter(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  color: Colors.white,
                ),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pushReplacementNamed(context, '/user_data');
          }
        }

      },
      builder: (context, state) {
        print("+++++++++");
        print(state.runtimeType);


        return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: (state is SignUpStartSuccess)
                ? signUpEmail()
                : (state is SignUpEmailAddedState)
                    ? signUpEmailAdded()
                    : (state is SignUpUserNameAddedState)
                        ? signUpUserNameAdded()
                        : (state is SignUpUserPasswordState)
                            ? signUpPasswordCheckAgain()
                            : (state is SignupAccountCreationLoading ||  state is SignupAccountCreationSuccessful || state is SignUpPasswordErrorState)
                                ? Scaffold(
                                    backgroundColor: isDarkTheme
                                        ? darkScaffoldColor
                                        : lightScaffoldColor,
                                    appBar: AppBar(
                                      backgroundColor: isDarkTheme
                                          ? darkScaffoldColor
                                          : lightScaffoldColor,
                                    ),
                                body: Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 10,right: 10),
                                      child: Column(
                                        children: [
                                          const StepProgressIndicator(
                                            totalSteps: 4,
                                            currentStep: 4,
                                            selectedColor: Colors.pinkAccent,
                                            unselectedColor: Colors.grey,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(top: 10, bottom: 5),
                                            alignment: Alignment.topLeft,
                                            child: const HazelFieldHeading(text: "Hold on for a moment while we create your account and log you in."),
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child:
                                            const HazelFieldLabel(text: "Welcome to Hazel! Thanks for joining us."),
                                          ),
                                        ],
                                      ),
                                    ),
                                   const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 5,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        'If you encounter any bugs or glitches or just want us to add some feature that you would like to see on our platform, feel free to say that in our feedback section in settings panel.',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                          textStyle: Theme.of(context).textTheme.labelSmall,
                                          color: isDarkTheme ? Colors.grey : Colors.grey,
                                        ),
                                      ),
                                    )

                                  ],
                                ),
                                  )
                                : Container());
      },
    );
  }
}
