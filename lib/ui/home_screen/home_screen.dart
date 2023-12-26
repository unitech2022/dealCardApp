import 'dart:io';

import 'package:deal_card/bloc/auth_cubit/auth_cubit.dart';
import 'package:deal_card/bloc/home_cubit/home_cubit.dart';
import 'package:deal_card/core/animations/slide_transtion.dart';
import 'package:deal_card/core/enums/loading_status.dart';
import 'package:deal_card/core/helpers/helper_functions.dart';
import 'package:deal_card/core/layout/app_fonts.dart';
import 'package:deal_card/core/layout/palette.dart';
import 'package:deal_card/core/shimmer/shimmer_widget.dart';
import 'package:badges/badges.dart' as badges;
import 'package:deal_card/core/widgets/texts.dart';
import 'package:deal_card/ui/components/container_shimmer.dart';
import 'package:deal_card/ui/components/no_internet_widget.dart';
import 'package:deal_card/ui/favoraite_screen/favoraite_screen.dart';
import 'package:deal_card/ui/home_screen/components/carousel_widget.dart';
import 'package:deal_card/ui/home_screen/components/drawer_widget.dart';
import 'package:deal_card/ui/home_screen/components/list_field_widget.dart';
import 'package:deal_card/ui/notifications_screen/notifications_screen.dart';
import 'package:deal_card/ui/orders_screen/orders_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/app_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    inItFCMNotification();

  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      switch (state.getHomeState) {
        case RequestState.noInternet:
          return NoInternetWidget(
            onPress: () {
              HomeCubit.get(context).getHomeUser(context: context);
            },
          );
        case RequestState.loaded:
          return Scaffold(
              key: scaffoldkey,
              appBar: AppBar(
                elevation: 0,
                centerTitle: false,
                automaticallyImplyLeading: false,
                leading: IconButton(
                    onPressed: () {
                      scaffoldkey.currentState!.openDrawer();
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: Palette.mainColor,
                      size: 30,
                    )),
                title: Texts(
                  title: "الرئيسية".tr(),
                  family: AppFonts.caB,
                  size: 18,
                  textColor: Palette.mainColor,
                  height: 2.0,
                ),
                actions: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Palette.mainColor),
                    child: Center(
                      child: IconButton(
                          onPressed: () {
                            pushTranslationPage(
                                context: context,
                                transtion: FadTransition(page: OrdersScreen()));
                            // AuthCubit.get(context).postSmsCode();
                          },
                          icon: Icon(
                            Icons.shopping_bag_rounded,
                            color:Palette.secondaryColor,
                            size: 20,
                          )),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Palette.mainColor),
                    child: Center(
                      child: IconButton(
                          onPressed: () {
                            showBottomSheetWidget(
                                context,
                                callUs(
                                    context,
                                    state.homeResponse != null
                                        ? state.homeResponse!.callUsNumber.valueAr
                                        : ""));
                          },
                          icon: Icon(
                            Icons.call,
                            color: Palette.secondaryColor,
                            size: 20,
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      pushTranslationPage(
                          context: context,
                          transtion: FadTransition(page: NotificationsScreen()));
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Palette.mainColor),
                      child: Center(
                        child: badges.Badge(
                          badgeContent:state.homeResponse == null && state.homeResponse!.countAlerts==0?
                          SizedBox()
                          :Text(
                            state.homeResponse!.countAlerts.toString(),
                            style:
                                const TextStyle(color: Colors.white, height: 1.5),
                          ),
                          position: badges.BadgePosition.topStart(top: -20),
                          child: Icon(
                            Icons.notifications_active,
                            color: Palette.secondaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
                // actions: const [IconAlertWidget()],
              ),
              drawer: const DrawerWidget(),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    sizedHeight(20),
                    // *** slider
                    CarouselWidget(
                      offers: state.homeResponse!.offers.isEmpty
                          ? []
                          : state.homeResponse!.offers,
                    ),

                    // const SizedBox(
                    //   height: 30,
                    // ),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 30),
                    //   child: Row(
                    //     children: [
                    //       Texts(
                    //         title: "الأقسام".tr(),
                    //         family: AppFonts.taB,
                    //         size: 16,
                    //         textColor: Colors.black,
                    //         height: 2.0,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(
                      height: 35,
                    ),

                    // ** fields
                    ListFieldWidget(
                      fields: state.homeResponse!.fields,
                      code: state.homeResponse!.codeMarkets,
                    ),
                    sizedHeight(80),
                  ],
                ),
              ));
        case RequestState.error:
        case RequestState.loading:
          return Scaffold(
            body: getShimmerWidget(
              child: ListView(
                children: [
                  sizedHeight(5),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Container(
                          height: 15,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  sizedHeight(20),
                  // *** slider
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.grey
                        // borderRadius: BorderRadius.circular(15)
                        ),
                  ),
                  sizedHeight(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey)),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey))
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),

                  Container(
                    height: 140,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 7),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                  ),

                  const ContainerShimmer(
                    hieght: 140,
                  ),
                  const ContainerShimmer(
                    hieght: 140,
                  ),
                  const ContainerShimmer(
                    hieght: 140,
                  ),
                ],
              ),
            ),
          );
        default:
          return Scaffold(
            body: getShimmerWidget(
              child: ListView(
                children: [
                  sizedHeight(5),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Container(
                          height: 15,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  sizedHeight(20),
                  // *** slider
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.grey
                        // borderRadius: BorderRadius.circular(15)
                        ),
                  ),
                  sizedHeight(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey)),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey))
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),

                  Container(
                    height: 140,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 7),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                  ),

                  const ContainerShimmer(
                    hieght: 140,
                  ),
                  const ContainerShimmer(
                    hieght: 140,
                  ),
                  const ContainerShimmer(
                    hieght: 140,
                  ),
                ],
              ),
            ),
          );
      }
    });
  }

  void showBottomSheetWidget(context, child) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        isDismissible: true,
        builder: (context) {
          return child;
        });
  }

  callUs(context, phone) => Container(
        height: 220,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18.0,
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 24,
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.5),
                  color: const Color(0xFFDCDCDF),
                ),
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        pop(context);
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Texts(title: "تواصل مع خدمة العملاء".tr(), family: AppFonts.taM, size: 16),
           const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          launch('tel:+$phone');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFF6F2F2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.call,
                                size: 30,
                                color: Palette.secondaryColor,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Texts(
                                  title: "اتصال".tr(),
                                  family: AppFonts.caB,
                                  size: 15,
                                  textColor: Colors.black)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          pop(context);
                          // await FlutterLaunch.launchWhatsapp(
                          //     phone: "00966557755462", message: "مرحبا").then((value) => null);
                          var whatsappURl_android =
                              "whatsapp://send?phone=+$phone";
                          var whatappURL_ios =
                              "https://wa.me/+$phone?text=${Uri.parse("مرحبا بك")}";
                          if (Platform.isIOS) {
                            // for iOS phone only
                            if (await canLaunch(whatappURL_ios)) {
                              await launch(whatappURL_ios,
                                  forceSafariVC: false);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          new Text("whatsapp no installed")));
                            }
                          } else {
                            // android , web
                            if (await canLaunch(whatsappURl_android)) {
                              await launch(whatsappURl_android);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          new Text("whatsapp no installed")));
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFF6F2F2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.whatsapp,
                                size: 30,
                                color: Palette.secondaryColor,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Texts(
                                  title: "واتساب".tr(),
                                  family: AppFonts.caB,
                                  size: 15,
                                  textColor: Colors.black)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
