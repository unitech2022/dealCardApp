import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:deal_card/bloc/order_cubit/order_cubit.dart';
import 'package:deal_card/core/enums/loading_status.dart';
import 'package:deal_card/core/helpers/helper_functions.dart';
import 'package:deal_card/core/layout/app_fonts.dart';
import 'package:deal_card/core/layout/palette.dart';
import 'package:deal_card/core/router/routes.dart';
import 'package:deal_card/core/utils/api_constatns.dart';
import 'package:deal_card/core/utils/app_model.dart';
import 'package:deal_card/core/widgets/circular_progress.dart';
import 'package:deal_card/core/widgets/custom_button.dart';
import 'package:deal_card/core/widgets/texts.dart';
import 'package:deal_card/models/market_model.dart';
import 'package:deal_card/ui/daetails_market_screen/cards_of_market_screen/cards_of_market_screen.dart';
import 'package:deal_card/ui/daetails_market_screen/show_image_screen/show_image_screen.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../core/animations/slide_transtion.dart';
import '../cards_screen/subscrip_card_screen/subscrip_card_screen.dart';
import '../scan_qrcode_screen/scan_qrcode_screen.dart';

class DetailsMarketScreen extends StatefulWidget {
  final MarketModel marketModel;

  const DetailsMarketScreen({super.key, required this.marketModel});

  @override
  State<DetailsMarketScreen> createState() => _DetailsMarketScreenState();
}

class _DetailsMarketScreenState extends State<DetailsMarketScreen> {
  int index = 1;
  final _controllerCode = TextEditingController();
  String time = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: Container(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
              widget.marketModel.cardIds=="0"?SizedBox() :   Expanded(
                    child: CustomButton(
                      radius: 25,
                      elevation: 10,
                      backgroundColor: Palette.secondaryColor,
                      titleColor: Palette.mainColor,
                      title: "احصل علي الخصم".tr(),
                      //"للتواصل".tr(),
                      onPressed: () async {
                        // await getUrl();
                        if (isLogin()) {
                          // typeNameOfBooking(context);
                          pushPage(context, CardsOfMarketScreen(titleBar: AppModel.lang==AppModel.arLang?widget.marketModel.nameAr:widget.marketModel.nameEng,cardIds:widget.marketModel.cardIds,marketModel: widget.marketModel,));
                          // pushPage(context, ScanQRCodeScreen());
                        } else {
                          pushTranslationPage(
                              context: context,
                              transtion: FadTransition(
                                  page: SubscribeCardScreen(
                                      type: 1, id: 1, titleBar: "")));
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: CustomButton(
                      radius: 25,
                      elevation: 10,
                      backgroundColor: Palette.secondaryColor,
                      titleColor: Palette.mainColor,
                      title:
                          // "احجز الآن".tr(),
                          "للتواصل".tr(),
                      onPressed: () async {
                        await getUrl();

                        // typeNameOfBooking(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleButtonWidget(
                    child: Icon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.green,
                      size: 25,
                    ),
                    color: Palette.white,
                    onPressed: () async {
                      var whatsappURl_android =
                          "whatsapp://send?phone=+${widget.marketModel.phone}";
                      var whatappURL_ios =
                          "https://wa.me/+${widget.marketModel.phone}?text=${Uri.parse("مرحبا بك")}";
                      if (Platform.isIOS) {
                        // for iOS phone only
                        if (await canLaunch(whatappURL_ios)) {
                          await launch(whatappURL_ios, forceSafariVC: false);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: new Text("whatsapp no installed")));
                        }
                      } else {
                        // android , web
                        if (await canLaunch(whatsappURl_android)) {
                          await launch(whatsappURl_android);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: new Text("whatsapp no installed")));
                        }
                      }
                    },
                  ),
                  CircleButtonWidget(
                    child: Icon(
                      FontAwesomeIcons.phone,
                      color: Colors.lightBlue,
                      size: 25,
                    ),
                    color: Palette.white,
                    onPressed: () {
                      launch('tel:+${widget.marketModel.phone}');
                    },
                  )
                ],
              )
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          leading: const BackButton(
            color: Palette.mainColor,
          ),

          title: Texts(
            title: "تفاصيل المتجر".tr(),
            family: AppFonts.caB,
            size: 18,
            textColor: Palette.mainColor,
            height: 2.0,
          ),
          // actions: const [IconAlertWidget()],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Texts(
                      title: AppModel.lang == AppModel.arLang
                          ? widget.marketModel.nameAr
                          : widget.marketModel.nameEng,
                      family: AppFonts.caB,
                      size: 18,
                      line: 3,
                      textColor: Colors.black,
                      height: 2.0,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10, top: 8, bottom: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Texts(
                        title: AppModel.lang == AppModel.arLang
                            ? widget.marketModel.aboutAr
                            : widget.marketModel.aboutEng,
                        family: AppFonts.taM,
                        size: 18,
                        line: 30,
                        textColor: Colors.grey,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  //  if (state.photosStat == RequestState.pagination)

                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220,
                      childAspectRatio: 1.5 / 2,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3),
                  itemBuilder: (BuildContext context, int index) {
                    String photo = widget.marketModel.images.split("#")[index];
                    return GestureDetector(
                      onTap: () {
                        pushPage(context, ShowImageScreen(images: photo));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: CachedNetworkImage(
                          // placeholder: (context, url)=>PlaceHolderWidget(),
                          // cacheManager: CustomCacheManager.instance,
                          key: UniqueKey(),
                          imageUrl: ApiConstants.imageUrl(photo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  itemCount: widget.marketModel.images.split("#").length),
              SizedBox(
                height: 150,
              )
            ],
          ),
        )

        // CarouselSlider.builder(
        //   options: CarouselOptions(
        //     onPageChanged: (newIndex, car) {
        //       index = newIndex;
        //       setState(() {});
        //     },
        //     // aspectRatio: 0,
        //     //  enlargeCenterPage: true,
        //     aspectRatio: .9,
        //     viewportFraction: 1,
        //     scrollDirection: Axis.horizontal,
        //     height: MediaQuery.of(context).size.height / 2,
        //     autoPlay: false,
        //     reverse: true,
        //     enableInfiniteScroll: true,
        //     initialPage: 0,
        //   ),
        //   itemCount: widget.marketModel.images.split("#").length,
        //   itemBuilder:
        //       (BuildContext context, int itemIndex, int pageViewIndex) {
        //     String image = widget.marketModel.images.split("#")[itemIndex];
        //     return InkWell(
        //       onTap: () {
        //         pushTranslationPage(
        //             context: context,
        //             transtion: FadTransition(
        //                 page: ShowImageScreen(
        //               images: widget.marketModel.images.split("#"),
        //             )));
        //       },
        //       child: Container(
        //         height: 250,
        //         width: double.infinity,
        //         decoration: const BoxDecoration(
        //             // borderRadius: BorderRadius.circular(15)
        //             ),
        //         child: ClipRRect(
        //             // borderRadius: BorderRadius.circular(15),
        //             child: CachedNetworkImage(
        //           imageUrl: ApiConstants.imageUrl(image),
        //           width: double.infinity,
        //           height: double.infinity,
        //           fit: BoxFit.cover,
        //           errorWidget: (context, url, error) => const Icon(Icons.error),
        //         )),
        //       ),
        //     );
        //   },
        // ),
        // const SizedBox(
        //   height: 20,
        // ),
        // // ** indicator
        // CarouselIndicator(
        //   width: 8,
        //   height: 8,
        //   activeColor: Palette.mainColor,
        //   color: Colors.grey.withOpacity(.5),
        //   cornerRadius: 40,
        //   count: widget.marketModel.images.split("#").length,
        //   index: index,
        // ),
        );
  }

  Future getUrl() async {
    var url = Uri.parse(widget.marketModel.link);
    // if (!await canLaunchUrl(url)) {
    //   await launchUrl(url, mode: LaunchMode.externalApplication);
    // }else{
    //   print("error");
    // }

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future typeNameOfBooking(BuildContext contextt) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  width: double.infinity,
                  // height: heightScreen(context) / 1.5,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    color: Colors.white,
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Texts(
                          title: "بيانات الطلب".tr(),
                          family: AppFonts.taB,
                          size: 18),
                      sizedHeight(25),

                      Row(
                        children: [
                          Texts(
                              title: "موعد الحجز".tr(),
                              family: AppFonts.taM,
                              size: 14),
                        ],
                      ),
                      sizedHeight(10),
                      GestureDetector(
                        onTap: () {
                          showDateTimePicker2(context, onConfirm: (date) {
                            pop(context);
                            print(formatDate(date));
                            time = formatDate(date);
                          OrderCubit.get(context).changeTimeOrder(timeOrder: time);
                          });
                        },
                        child: Container(
                            width: double.infinity,
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            // margin: EdgeInsets.symmetric(horizontal: 30),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: Colors.black38, width: .8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Texts(
                                    title: state.timeOrder == "" ? "موعد الحجز".tr() : state.timeOrder,
                                    family: AppFonts.taM,
                                    size: 12),
                                Icon(Icons.calendar_month)
                              ],
                            )),
                      ),
                      sizedHeight(30),
                      Row(
                        children: [
                          Texts(
                              title: "تفاصيل الحجز".tr(),
                              family: AppFonts.taM,
                              size: 14),
                        ],
                      ),
                      sizedHeight(10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        // margin: EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(color: Colors.black38, width: .8)),
                        child: TextField(
                          controller: _controllerCode,
                          maxLines: 4,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "تفاصيل اخري".tr(),
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
                      Row(
                        children: [
                          Expanded(
                            child: state.addOrderState == RequestState.loading
                                ? SizedBox(child: CustomCircularProgress(fullScreen: false,))
                                : CustomButton(
                                    onPressed: () {

                                      if (time != "") {
                                        OrderCubit.get(context).addOrder(
                                            context: contextt,
                                            timeOrder: time,
                                            marketId: widget.marketModel.id,
                                            desc: _controllerCode.text).then((value) =>   _controllerCode.clear());
                                      }



                                    },
                                    title: "حجز".tr(),
                                  ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CustomButton(
                              backgroundColor: Colors.red,
                              onPressed: () {
                                _controllerCode.clear();
                                pop(context);
                              },
                              title: "الغاء".tr(),
                            ),
                          ),
                        ],
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
      },
    );
  }
}

class CircleButtonWidget extends StatelessWidget {
  final Widget child;
  final Color color;
  final void Function() onPressed;

  const CircleButtonWidget({
    super.key,
    required this.child,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      textColor: Colors.white,
      child: child,
      elevation: 10,
      padding: EdgeInsets.all(16),
      shape: CircleBorder(),
    );
  }
}
