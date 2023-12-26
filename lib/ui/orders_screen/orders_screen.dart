import 'package:cached_network_image/cached_network_image.dart';
import 'package:deal_card/bloc/order_cubit/order_cubit.dart';
import 'package:deal_card/core/helpers/helper_functions.dart';
import 'package:deal_card/core/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/animations/slide_transtion.dart';
import '../../core/enums/loading_status.dart';
import '../../core/layout/app_fonts.dart';
import '../../core/layout/palette.dart';
import '../../core/utils/api_constatns.dart';
import '../../core/utils/app_model.dart';
import '../../core/widgets/empty_list_widget.dart';
import '../../core/widgets/texts.dart';
import '../../models/scan_response.dart';
import '../cards_screen/subscrip_card_screen/subscrip_card_screen.dart';
import '../components/no_internet_widget.dart';
import '../notifications_screen/notifications_shimmer_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    OrderCubit.get(context).getScansUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(
          color: Palette.mainColor,
        ),

        title: Texts(
          title: "طلبات الخصم".tr(),
          family: AppFonts.caB,
          size: 18,
          textColor: Palette.mainColor,
          height: 2.0,
        ),
        // actions: const [IconAlertWidget()],
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          return isLogin()? getBody(state):
          Center(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: CustomButton(title: "سجل الدخول".tr(), onPressed: (){
              pushTranslationPage(
                  context: context,
                  transtion: FadTransition(
                      page: SubscribeCardScreen(
                          type: 2, id: 1, titleBar: "")));
            }),
          ))
          ;
        },
      ),
    );
  }

  Widget getBody(OrderState state) {
    switch (state.getOrdersState) {
      case RequestState.loaded:
        return state.scanns.isEmpty
            ? EmptyListWidget(message: "لاتوجد طلبات".tr())
            : ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: state.scanns.length,
            itemBuilder: (ctx,index){
              ScanResponse order=state.scanns[index];
              return Container(
                height: 80,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x29b6b6b6),
                      offset: Offset(0, 0),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey,width: .8)
                      ),
                      height: 60,
                      width: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl:
                          ApiConstants.imageUrl(order.market!.logoImage),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Texts(
                          title:AppModel.lang==AppModel.arLang? order.market!.nameAr!:order.market!.nameAr!,
                          family: AppFonts.caB,
                          textColor:Colors.black,
                          size: 20,
                          // textColor: const Color(0xffC3C3C3),
                        ),
                        Texts(
                          title: formatDate(DateTime.parse(order.scann!.createdAt!)),
                          family: AppFonts.caR,
                          size: 15,
                          textColor: const Color(0xffC3C3C3),
                        ),
                        // Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     Texts(
                        //       title: "موعدالحجز : ".tr(),
                        //       family: AppFonts.caR,
                        //       size: 12,
                        //       textColor: const Color(0xffC3C3C3),
                        //     ),
                        //     Texts(
                        //       title: order.timeOrder,
                        //       family: AppFonts.caB,
                        //       size: 12,
                        //       textColor: const Color(0xffC3C3C3),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                   
                    
                  ],
                ),
              );
            });
      case RequestState.loading:
      case RequestState.error:
        return const NotificationsShimmerWidget();

      case RequestState.noInternet:
        return NoInternetWidget(
          onPress: () {
            OrderCubit.get(context).getScansUser();
          },
        );

      default:
        return const NotificationsShimmerWidget();
    }
  }
}
