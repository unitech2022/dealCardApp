import 'dart:io';

import 'package:deal_card/bloc/home_cubit/home_cubit.dart';
import 'package:deal_card/core/layout/palette.dart';
import 'package:deal_card/core/utils/app_model.dart';
import 'package:deal_card/ui/cards_screen/recovery_details_screen/recovery_details_screen.dart';
import 'package:deal_card/ui/favoraite_screen/favoraite_screen.dart';
import 'package:deal_card/ui/home_screen/home_screen.dart';
import 'package:deal_card/ui/search_screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upgrader/upgrader.dart';
import '../../core/animations/slide_transtion.dart';
import '../aboute_app_screen/aboute_app_screen.dart';

class NavigationScreen extends StatefulWidget {
  NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  String detailsCard = "";
  // List<Widget> _screensHome = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HomeCubit.get(context).getHomeUser();
  }

  @override
  Widget build(BuildContext context) {
    final appcastURL =
        'https://raw.githubusercontent.com/unitech2022/RecoveryApp/main/Appcast.xml';
    final cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);

    return BlocConsumer<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          floatingActionButton: FloatingActionButton(
            isExtended: true,

            backgroundColor: Palette.mainColor,
            onPressed: () {
              pushTranslationPage(
                  context: context,
                  transtion: FadTransition(
                      page:SearchScreen()));
            },
            child: Icon(
              Icons.search,
              size: 30,color: Palette.secondaryColor,
            ),
            //params
          ),
          body:  UpgradeAlert(

            upgrader:Platform.isAndroid? Upgrader(appcastConfig: cfg) :Upgrader(dialogStyle: UpgradeDialogStyle.cupertino),

            child: IndexedStack(
              index: state.currentNavIndex,
              children: [
                HomeScreen(),
               FevoraiteScreen(),
                RecoveryDetailsScreen(
                  cardDetials: state.homeResponse != null
                      ? AppModel.lang==AppModel.arLang?state.homeResponse!.cardDetails.valueAr:state.homeResponse!.cardDetails.valueEng
                      : "",
                ),
                AbouteAppScreen()
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
            activeColor: Palette.secondaryColor,

            iconSize: 30,
            inactiveColor: Colors.white.withOpacity(.3),
            backgroundColor: Palette.mainColor,

            elevation: 100,
            splashColor: Palette.secondaryColor.withOpacity(.5),

            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.defaultEdge,

            icons: [
              Icons.home_filled,
              Icons.favorite,
              Icons.credit_card,
              Icons.help
            ],

            leftCornerRadius: 32,
            rightCornerRadius: 32,
            activeIndex: state.currentNavIndex,
            shadow: BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 12,
              spreadRadius: 0.5,
              color: Palette.mainColor.withOpacity(.5),
            ),
            onTap: (index) {
              HomeCubit.get(context).changeCurrentIndexNav(index);
            },
            //other params
          ),
        );
      },
      listener: (BuildContext context, HomeState state) {
        // if (state.getHomeState == RequestState.loaded) {
        //   _screensHome = [
        //
        //   ];
        // }
      },
    );
  }
}
