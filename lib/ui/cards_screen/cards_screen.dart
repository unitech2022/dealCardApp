import 'package:cached_network_image/cached_network_image.dart';
import 'package:deal_card/bloc/cards_cubit/cards_cubit.dart';
import 'package:deal_card/core/animations/slide_transtion.dart';
import 'package:deal_card/core/enums/loading_status.dart';
import 'package:deal_card/core/helpers/helper_functions.dart';
import 'package:deal_card/core/layout/app_fonts.dart';
import 'package:deal_card/core/router/routes.dart';
import 'package:deal_card/core/utils/api_constatns.dart';
import 'package:deal_card/core/utils/app_model.dart';
import 'package:deal_card/core/widgets/custom_button.dart';
import 'package:deal_card/core/widgets/empty_list_widget.dart';
import 'package:deal_card/models/subscribe_model.dart';
import 'package:deal_card/ui/cards_screen/components/shimmer_cards.dart';
import 'package:deal_card/ui/cards_screen/subscrip_card_screen/subscrip_card_screen.dart';
import 'package:deal_card/ui/components/no_internet_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/layout/palette.dart';
import '../../core/widgets/texts.dart';
import '../../models/card_response.dart';

class CardsScreen extends StatefulWidget {
  final String titleBar;

  const CardsScreen({super.key, required this.titleBar});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  @override
  void initState() {
    super.initState();

    CardsCubit.get(context).getCards(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,

        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Palette.mainColor,
          ),
          onPressed: () {
            pushPageRoutName(context, nav);
          },
        ),
        title: Texts(
          title: widget.titleBar,
          family: AppFonts.caB,
          size: 25,
          textColor: Palette.mainColor,
          height: 2.0,
        ),
        // actions: const [IconAlertWidget()],
      ),
      body: BlocBuilder<CardsCubit, CardsState>(
        builder: (context, state) {
          switch (state.getCardsState) {
            case RequestState.loaded:
              return  state.cardResponse!.cards.isEmpty?
              EmptyListWidget(message: "NotCards".tr())
              
              :ListView.builder(
                  itemCount: state.cardResponse!.cards.length,
                  itemBuilder: (ctx,index){
                CardList cardList=state.cardResponse!.cards[index];
                return   Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    height: 250,
                    margin: const EdgeInsets.only(bottom: 25),
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.grey,width: .8),a
                        borderRadius: BorderRadius.circular(10)),
                    child: Stack(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: ApiConstants.imageUrl(
                                cardList.card!.image),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                          ),
                        ),
                      ),
                      cardList.isSSubscribe
                          ? Positioned(
                          bottom: 25,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment(0.0, -1.279),
                                    end: Alignment(0.0, 0.618),
                                    colors: [
                                      Color(0x000d0d0d),
                                      Color(0xff000000)
                                    ],
                                    stops: [
                                      0.0,
                                      1.0
                                    ]),
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /// ****
                                Row(
                                  children: [
                                    Texts(
                                      title: "كود الاشتراك : ".tr(),
                                      family: AppFonts.caM,
                                      size: 15,
                                      textColor: Colors.white,
                                      height: 1.0,
                                    ),
                                    Texts(
                                      title: cardList
                                          .subscription!.code.toString()
                                      ,
                                      family: AppFonts.caM,
                                      size: 15,
                                      textColor: Colors.white,
                                      height: 1.0,
                                    )
                                  ],
                                ),

                                Row(
                                  children: [
                                    Texts(
                                      title: "الاسم : ".tr(),
                                      family: AppFonts.caM,
                                      size: 15,
                                      textColor: Colors.white,
                                      height: 1.0,
                                    ),
                                    Texts(
                                      title: state
                                          .cardResponse!
                                          .userDetailResponse!
                                          .fullName
                                          .split(",")[0] +
                                          " " +
                                          state
                                              .cardResponse!
                                              .userDetailResponse!
                                              .fullName
                                              .split(",")[1],
                                      family: AppFonts.caM,
                                      size: 15,
                                      textColor: Colors.white,
                                      height: 1.0,
                                    )
                                  ],
                                ),

                                Row(
                                  children: [
                                    Texts(
                                      title: "رقم الهاتف : ".tr(),
                                      family: AppFonts.caM,
                                      size: 15,
                                      textColor: Colors.white,
                                      height: 1.0,
                                    ),
                                    Texts(
                                      title: state.cardResponse!
                                          .userDetailResponse!.userName,
                                      family: AppFonts.caM,
                                      size: 15,
                                      textColor: Colors.white,
                                      height: 1.0,
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Texts(
                                      title: "تاريخ الانتهاء : ".tr(),
                                      family: AppFonts.caM,
                                      size: 15,
                                      textColor: Colors.white,
                                      height: 1.0,
                                    ),
                                    Texts(
                                      title: cardList
                                          .subscription!.expiredDate
                                          .split("T")[0],
                                      family: AppFonts.caM,
                                      size: 15,
                                      textColor: Colors.white,
                                      height: 1.0,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ))
                          : SizedBox(),
                      cardList.isSSubscribe
                          ? SizedBox()
                          : Positioned(
                        bottom: 0,
                        left: 40,
                        right: 40,
                        child: CustomButton(
                          radius: 25,
                          elevation: 10,
                          backgroundColor: Palette.secondaryColor,
                          titleColor: Palette.mainColor,
                          title: "احصل علي الكارد".tr(),
                          onPressed: () {
                            // print(state
                            //     .cardResponse!.userDetailResponse!.id);
                            if (!isLogin()&&state.cardResponse!.userDetailResponse==null) {
                              pushTranslationPage(
                                  context: context,
                                  transtion: FadTransition(
                                      page: SubscribeCardScreen(
                                          type: 0,
                                          id: cardList.card!.id,
                                          titleBar: widget.titleBar)));
                            } else {
                              print("wewqe");

                              CardsCubit.get(context)
                                  .setupSDKSession(
                                firstName: state.cardResponse!
                                    .userDetailResponse!.fullName
                                    .split(",")[0],
                                lastName: state.cardResponse!
                                    .userDetailResponse!.fullName
                                    .split(",")[1],
                                email: state.cardResponse!
                                    .userDetailResponse!.email,
                                phone: state.cardResponse!
                                    .userDetailResponse!.userName,
                                ammount: cardList.card!.price
                                    .toString(),
                              )
                                  .then((value) {
                                SubscribeModel
                                subscribeModel = SubscribeModel(
                                    id: 0,
                                    code: 0,
                                    firstName:
                                    state
                                        .cardResponse!
                                        .userDetailResponse!
                                        .fullName
                                        .split(",")[0],
                                    lastName:
                                    state
                                        .cardResponse!
                                        .userDetailResponse!
                                        .fullName
                                        .split(",")[1],
                                    cardId:
                                    cardList.card!.id,
                                    phone:
                                    state
                                        .cardResponse!
                                        .userDetailResponse!
                                        .userName,
                                    address: state
                                        .cardResponse!
                                        .userDetailResponse!
                                        .address,
                                    status: 0,
                                    createdAt: "createdAt",
                                    expiredDate: 'sdf',
                                    userId: state.cardResponse!
                                        .userDetailResponse!.id);
                                CardsCubit.get(context).startSDK(
                                    subscribeModel,
                                    type: 0,
                                    context: context,
                                    titleBar: widget.titleBar);
                              });
                            }
                          },
                        ),
                      ),
                    ]),
                  ),
                );
              });

            case RequestState.loading:
            case RequestState.error:
              return const ShimmerCardsWidget();
            case RequestState.noInternet:
              return NoInternetWidget(
                onPress: () {
                  CardsCubit.get(context).getCards(context: context);
                },
              );

            default:
              return const ShimmerCardsWidget();
          }
        },
      ),
    );
  }

//   Future showDialogPayment() {

//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) {
//         return SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom),
//             child: Container(
//               width: double.infinity,
//               // height: heightScreen(context) / 1.5,
//               padding: EdgeInsets.symmetric(horizontal: 15),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(15),
//                     topRight: Radius.circular(15)),
//                 color: Colors.white,
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [

//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );

//   }
}
