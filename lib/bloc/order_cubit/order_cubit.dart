import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:deal_card/core/router/routes.dart';
import 'package:deal_card/models/order.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import '../../../../core/enums/loading_status.dart';
import 'package:http/http.dart' as http;
import '../../../../core/helpers/helper_functions.dart';
import '../../../../core/utils/api_constatns.dart';
import '../../../../core/utils/app_model.dart';

import 'dart:ui' as ui;

import '../../core/utils/utils.dart';
import '../../models/scan_response.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(const OrderState());

  static OrderCubit get(context) => BlocProvider.of<OrderCubit>(context);

  changeCurrentIndexNav(int newIndex) {
    emit(state.copyWith(currentIndexTap: newIndex));
  }

  changeTimeOrder({timeOrder}) {
    emit(state.copyWith(
        timeOrder: timeOrder, addTimeOrderState: RequestState.loaded));
  }

// ** add order
  Future addOrder({context, desc, timeOrder, marketId}) async {
    emit(state.copyWith(addOrderState: RequestState.loading));
    var headers = {'Authorization': AppModel.token};
    var request = http.MultipartRequest(
        'POST', Uri.parse('${ApiConstants.baseUrl}/orders/add-order'));

    request.fields.addAll({
      // 'providerId': '4',
      'UserId': AppModel.userId!,
      'timeOrder': timeOrder,

      'MarketId': marketId.toString(),
      'desc': desc
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (kDebugMode) {
      print("${response.statusCode} ======> addOrder");
    }
    if (response.statusCode == 200) {
      pop(context);
      pushPageRoutName(context, orders);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: "تم الحجز بنجاح",
        // desc: '',
        // btnCancelOnPress: () {},
        btnOkOnPress: () {
          // pop(context);
        },
      )..show();
      emit(state.copyWith(addOrderState: RequestState.loaded));
    } else {
      // pop(context);
      emit(state.copyWith(addOrderState: RequestState.error));
    }
  }

  Future getOrders() async {
    emit(state.copyWith(getOrdersState: RequestState.loading));

    var request = http.Request(
        'GET',
        Uri.parse(
            '${ApiConstants.baseUrl}/orders/get-Orders?UserId=${AppModel.userId}'));

    http.StreamedResponse response = await request.send();
    if (kDebugMode) {
      print("${response.statusCode} ======> getOrders");
    }
    if (response.statusCode == 200) {
      String jsonDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonDataString);

      emit(state.copyWith(
          getOrdersState: RequestState.loaded,
          orders: List<Order>.from(
              (jsonData as List).map((e) => Order.fromJson(e)))));
    } else {
      // pop(context);
      emit(state.copyWith(getOrdersState: RequestState.error));
    }
  }

  /// scans
  Future getScansUser() async {
    emit(state.copyWith(getOrdersState: RequestState.loading));

    var request = http.Request(
        'GET',
        Uri.parse(
            '${ApiConstants.baseUrl}/scanns/get-scanns-by-userId?UserId=${AppModel.userId}'));

    http.StreamedResponse response = await request.send();
    if (kDebugMode) {
      print("${response.statusCode} ======> getScansUser");
    }
    if (response.statusCode == 200) {
      String jsonDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonDataString);

      emit(state.copyWith(
          getOrdersState: RequestState.loaded,
          scanns: List<ScanResponse>.from(
              (jsonData as List).map((e) => ScanResponse.fromJson(e)))));
    } else {
      // pop(context);
      emit(state.copyWith(getOrdersState: RequestState.error));
    }
  }

// ** update order

  List<String> textOrderStatus = [
    "في انتظار التأكيد",
    "تم تأكيد الطلب بنجاح",
    "جارى التجهيز",
    "تم التسليم",
    "تم الغاء الطلب"
  ];

//** get order details
  Future getOrderDetails(id, {context}) async {
    emit(state.copyWith(getOrderDetailsState: RequestState.loading));


    var request = http.MultipartRequest('GET',Uri.parse(
    '${ApiConstants.baseUrl}/orders/get-OrderDetails?orderId=$id'));


    http.StreamedResponse response = await request.send();

    if (kDebugMode) {
      print("${response.statusCode} ======> getOrderDetails");
    }
    if (response.statusCode == 200) {
      String jsonDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonDataString);
      emit(state.copyWith(
          getOrderDetailsState: RequestState.loaded,
          orderResponseDetails: OrderResponseDetails.fromJson(jsonData)));
      // getCarts(isState: false);
    } else {
      emit(state.copyWith(getOrderDetailsState: RequestState.error));
    }
  }

  //** format image marker */
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
