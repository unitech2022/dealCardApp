import 'package:deal_card/core/enums/loading_status.dart';
import 'package:deal_card/core/helpers/helper_functions.dart';
import 'package:deal_card/core/utils/app_model.dart';
import 'package:deal_card/core/widgets/circular_progress.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/order_cubit/order_cubit.dart';
import '../../core/layout/app_fonts.dart';
import '../../core/layout/palette.dart';
import '../../core/widgets/texts.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailsScreen({required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    OrderCubit.get(context).getOrderDetails(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const BackButton(
          color: Palette.mainColor,
        ),

        title: Texts(
          title: "تفاصيل الطلب".tr(),
          family: AppFonts.caB,
          size: 18,
          textColor: Palette.mainColor,
          height: 2.0,
        ),
        // actions: const [IconAlertWidget()],
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          return state.getOrderDetailsState == RequestState.loading
              ? CustomCircularProgress(
                  fullScreen: true,
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Texts(
                              title: "تفاصيل الطلب".tr(),
                              family: AppFonts.caB,
                              size: 16,
                              textColor: Colors.black,
                            )
                          ],
                        ),
                        sizedHeight(15),
                        ContainnerData(
                          title: "رقم الطلب :".tr(),
                          value:
                              state.orderResponseDetails!.order!.id.toString(),
                        ),
                        ContainnerData(
                          title: "موعد الحجز :".tr(),
                          value: state.orderResponseDetails!.order!.timeOrder
                              .toString(),
                        ),
                        state.orderResponseDetails!.order!.desc!=""?     ContainnerData(
                          title: "وصف الحجز :".tr(),
                          value: state.orderResponseDetails!.order!.desc
                              .toString(),
                        ):SizedBox(),
                        sizedHeight(35),
                        Row(
                          children: [
                            Texts(
                              title: "تفاصيل المتجر".tr(),
                              family: AppFonts.caB,
                              size: 16,
                              textColor: Colors.black,
                            ),
                          ],
                        ),
                        ContainnerData(
                          title: "اسم المتجر :".tr(),
                          value: AppModel.lang == AppModel.arLang
                              ? state.orderResponseDetails!.market!.nameEng
                                  .toString()
                              : state.orderResponseDetails!.market!.nameEng
                                  .toString(),
                        ),
                        ContainnerData(
                          title: "وصف المتجر :".tr(),
                          value: AppModel.lang == AppModel.arLang
                              ? state.orderResponseDetails!.market!.aboutAr
                                  .toString()
                              : state.orderResponseDetails!.market!.aboutEng
                                  .toString(),
                        ),
                        ContainnerData(
                          title: "رقم المتجر :".tr(),
                          value: state.orderResponseDetails!.market!.phone
                              .toString(),
                        ),
                        sizedHeight(35),
                        Row(
                          children: [
                            Texts(
                              title: "صاحب الحجز".tr(),
                              family: AppFonts.caB,
                              size: 16,
                              textColor: Colors.black,
                            ),
                          ],
                        ),
                        ContainnerData(
                          title: "الاسم :".tr(),
                          value: state.orderResponseDetails!.userModel!.fullName
                              .toString(),
                        ),
                        ContainnerData(
                          title: "رقم الهاتف : ".tr(),
                          value:state.orderResponseDetails!.userModel!.userName
                               ,
                        ),
                        sizedHeight(35),
                        Texts(title: orderStatuses[state.orderResponseDetails!.order!.status], family: AppFonts.taB, size: 18,textColor: state.orderResponseDetails!.order!.status==0?
                          Colors.red:Colors.green,)
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}

class ContainnerData extends StatelessWidget {
  final String title, value;

  const ContainnerData({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50,
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: .8))),
      child: Row(
        children: [
          Texts(
            title: title,
            family: AppFonts.caM,
            size: 16,
          ),
          sizedWidth(30),
          Expanded(
            child: Texts(
              title: value,
              line: 3,
              family: AppFonts.caB,
              size: 16,
              textColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

List<String> orderStatuses = ["في حالة النتظار".tr(), "تم القبول".tr()];
