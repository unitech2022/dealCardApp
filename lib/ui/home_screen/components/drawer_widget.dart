import 'dart:io';

import 'package:deal_card/bloc/home_cubit/home_cubit.dart';
import 'package:deal_card/core/animations/slide_transtion.dart';
import 'package:deal_card/core/helpers/helper_functions.dart';
import 'package:deal_card/core/layout/app_fonts.dart';
import 'package:deal_card/core/layout/palette.dart';
import 'package:deal_card/core/router/routes.dart';
import 'package:deal_card/core/utils/api_constatns.dart';
import 'package:deal_card/core/utils/app_model.dart';
import 'package:deal_card/core/widgets/custom_button.dart';

import 'package:deal_card/core/widgets/texts.dart';
import 'package:deal_card/ui/business_owners_screen/business_owners_screen.dart';

import 'package:deal_card/ui/praivacy_screen/praivacy_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final _controllerCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: widthScreen(context) / 1.4,
      backgroundColor: Colors.white,
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 30),
                alignment: Alignment.center,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.asset(
                        "assets/images/logo.png",
                        height: 150,
                        width: 150,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Texts(
                      title: "Deal Card",
                      family: AppFonts.accL,
                      size: 30,
                      textColor: Palette.mainColor,
                    )
                  ],
                ),
              ),

              Container(
                height: 1,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Palette.mainColor,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // ItemDrawerWidget(
              //   title: "الرئيسية".tr(),
              //   onTap: () {
              //     pushPageRoutName(context, home);
              //   },
              //   color: const Color(0xff7E7E7E),
              //   icon: "assets/icons/home.svg",
              // ),
              // ItemDrawerWidget(
              //   title: "الاشعارات".tr(),
              //   onTap: () {
              //     pushTranslationPage(
              //         context: context,
              //         transtion:
              //             FadTransition(page: const NotificationsScreen()));
              //   },
              //   color: const Color(0xff7E7E7E),
              //   icon: 'assets/icons/noty.svg',
              // ),
              // ItemDrawerWidget(
              //   title: "ركوفرى كارد".tr(),
              //   onTap: () {
              //     pushTranslationPage(
              //         context: context,
              //         transtion:
              //             FadTransition(page: RecoveryDetailsScreen(cardDetials:state.homeResponse!.cardDetails)));
              //   },
              //   color: const Color(0xff7E7E7E),
              //   icon: 'assets/icons/card.svg',
              // ),
              // ItemDrawerWidget(
              //   title: "تواصل معنا".tr(),
              //   onTap: () {
              //     showBottomSheetWidget(
              //         context,
              //         callUs(
              //             context,
              //             state.homeResponse != null
              //                 ? state.homeResponse!.callUsNumber
              //                 : ""));
              //   },
              //   color: const Color(0xff7E7E7E),
              //   icon: 'assets/icons/call_menu.svg',
              // ),
              ItemDrawerWidget(
                title: "الشروط والأحكام".tr(),
                onTap: () {
                  pushTranslationPage(
                      context: context,
                      transtion: FadTransition(
                          page: PrivacyScreen(
                              seting: state.homeResponse!.pravicy)));
                },
                color: const Color(0xff7E7E7E),
                icon: 'assets/icons/us.svg',
              ),
              ItemDrawerWidget(
                title: "قيم التطبيق".tr(),
                onTap: () {
                  rateApp(
                      appPackageName: Platform.isAndroid
                          ? "com.discoveryzone.discoveryzon"
                          : "6468690136");
                },
                color: const Color(0xff7E7E7E),
                icon: 'assets/icons/star.svg',
              ),

              ItemDrawerWidget(
                title: "شارك التطبيق".tr(),
                onTap: () async {
                  await FlutterShare.share(
                      title: 'مشاركة التطبيق',
                      text: 'Deal Card تطبيق',
                      linkUrl: Platform.isIOS
                          ? "https://apps.apple.com/us/app/recovery-zone/id6468690136"
                          : 'https://play.google.com/store/apps/details?id=com.discoveryzone.discoveryzon',
                      chooserTitle: "");
                },
                color: const Color(0xff7E7E7E),
                icon: 'assets/icons/share.svg',
              ),
              ItemDrawerWidget(
                title: "آصحاب الآعمال".tr(),
                onTap: () {
                  // print(state.homeResponse!.codeMarkets.valueAr);
                  loginToMarkets(
                      context,
                      state.homeResponse!.fields
                          .firstWhere((element) => element.status == 1,
                              orElse: null)
                          .id,
                      state.homeResponse!.codeMarkets.valueAr);
                },
                color: const Color(0xff7E7E7E),
                icon: 'assets/icons/business.svg',
              ),
              ItemDrawerWidget(
                title: "تغيير اللغة".tr(),
                onTap: () {
                  pop(context);

                  showChangeLangDialog(context);
                },
                icon: 'assets/icons/translate.svg',
                color: const Color(0xff7E7E7E),
              ),
            ]),
          );
        },
      ),
    );
  }

  void showChangeLangDialog(BuildContext context) {
    showDialog<void>(
      context: context,

      barrierDismissible: false,
      // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            "تغيير اللغة".tr(),
            style: const TextStyle(fontSize: 20, color: Palette.mainColor),
          ),
          content: SizedBox(
            width: widthScreen(context),
            child: SingleChildScrollView(
              child: ListBody(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Text(
                        "هل تريد تغيير لغة التطبيق  ؟".tr(),
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        textAlign: TextAlign.center,
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    elevation: 0,
                    backgroundColor: Palette.mainColor,
                    titleColor: Colors.white,
                    onPressed: () async {
                      if (AppModel.lang == "en") {
                        AppModel.lang = "ar";
                        context.setLocale(const Locale('ar'));
                        await saveData(ApiConstants.langKey, 'ar');
                        pop(context);
                        Navigator.pushNamed(context, splash);
                      } else {
                        AppModel.lang = "en";
                        context.setLocale(const Locale('en'));
                        await saveData(ApiConstants.langKey, 'en');
                        pop(context);
                        Navigator.pushNamed(context, splash);
                      }
                    },
                    title: "تغيير".tr(),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: CustomButton(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    titleColor: Colors.red,
                    onPressed: () async {
                      pop(context);
                    },
                    title: "الغاء".tr(),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future<dynamic> loginToMarkets(BuildContext context, int id, String code) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              width: double.infinity,
              // height: heightScreen(context) / 1.5,
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // sizedHeight(15),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            pop(context);
                          },
                          icon: Icon(Icons.close, color: Colors.black))
                    ],
                  ),

                  sizedHeight(20),

                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38, width: .8)),
                    child: TextField(
                      controller: _controllerCode,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                          hintText: "اكتب كود الدخول".tr(),
                          hintStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontFamily: AppFonts.taM),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    onPressed: () {
                      print(_controllerCode.text + "lokklmlmk");
                      if (code == _controllerCode.text) {
                        pop(context);
                        pushTranslationPage(
                            context: context,
                            transtion:
                                FadTransition(page: BusinessOwnersScreen()));

                        _controllerCode.clear();
                      } else {
                        showTopMessage(
                            context: context,
                            customBar: CustomSnackBar.error(
                              backgroundColor: Colors.red,
                              message: "الكود غير صحيح".tr(),
                              textStyle: const TextStyle(
                                  fontFamily: "font",
                                  fontSize: 16,
                                  color: Colors.white),
                            ));
                      }
                    },
                    title: "دخول".tr(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ItemDrawerWidget extends StatelessWidget {
  final String title, icon;
  final void Function() onTap;

  final Color color;

  const ItemDrawerWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: .3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(icon,
                    height: 20, width: 20, color: Palette.mainColor),
                const SizedBox(
                  width: 13,
                ),
                Texts(
                    title: title,
                    family: AppFonts.taB,
                    size: 16,
                    height: .8,
                    textColor: Palette.mainColor,
                    widget: FontWeight.bold)
              ],
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Palette.mainColor,
                  size: 15,
                ))
          ],
        ),
      ),
    );
  }
}
