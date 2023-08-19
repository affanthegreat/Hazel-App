import 'package:flutter/cupertino.dart';
import 'package:hazel_client/constants/colors.dart';
import 'package:hazel_client/main.dart';
import 'package:hazel_client/screens/home/home_main_screen.dart';
import 'package:hazel_client/screens/home/user_profile.dart';
import 'package:hazel_client/screens/leaderboards/leaderboard.dart';
import 'package:hazel_client/screens/trending/trending.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../settings/settings.dart';


class HazelHome extends StatefulWidget {
  const HazelHome({super.key});

  @override
  State<HazelHome> createState() => _HazelHomeState();
}

class _HazelHomeState extends State<HazelHome> {


  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      const HazelMainScreen(),
      const HazelTrending(),
      const HazelLeaderboard(),
      const UserProfile(),
      const Settings()

    ];
  }


  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Iconsax.home),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.systemYellow,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Iconsax.trend_up),
        title: ("Trending"),
        activeColorPrimary: CupertinoColors.activeOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Iconsax.ranking),
        title: ("Leaderboards"),
        activeColorPrimary: CupertinoColors.activeOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Iconsax.profile_2user),
        title: ("Your account"),
        activeColorPrimary: CupertinoColors.systemYellow,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Iconsax.setting),
        title: ("Settings"),
        activeColorPrimary: CupertinoColors.activeGreen,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: isDarkTheme ? darkScaffoldColor : lightScaffoldColor, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      itemAnimationProperties:const  ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style12, // Choose the nav bar style with this property.
    );
  }


}
