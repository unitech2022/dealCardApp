import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:deal_card/bloc/home_cubit/home_cubit.dart';
import 'package:deal_card/core/enums/loading_status.dart';
import 'package:deal_card/core/utils/app_model.dart';
import 'package:deal_card/models/notification_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../../core/utils/api_constatns.dart';
part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(const NotificationState());
  static NotificationCubit get(context) =>
      BlocProvider.of<NotificationCubit>(context);

  List<NotificationModel> alerts = [];

  int currentPage = 1;

  int totalPages = 1;
  // ** get alerts
  Future getAlerts({context, page}) async {
    if (page == 1) {
      alerts = [];
      emit(const NotificationState(getAlertsState: RequestState.loading));
    } else {
      emit(const NotificationState(getAlertsState: RequestState.pagination));
    }

    var request = http.Request('GET',
        Uri.parse('${ApiConstants.baseUrl}/alerts/get-Alerts?page=$page'));

    http.StreamedResponse response = await request.send();
    if (kDebugMode) {
      print("${response.statusCode} ======> getAlerts");
    }
    if (response.statusCode == 200) {
      String jsonDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonDataString);

      AlertResponse alertResponse = AlertResponse.fromJson(jsonData);

      currentPage = alertResponse.currentPage;
      totalPages = alertResponse.totalPages;
      alerts.addAll(alertResponse.items);
      emit(state.copyWith(
          getAlertsState: RequestState.loaded,
          alertResponse: AlertResponse.fromJson(jsonData)));
      // getCarts(isState: false);
    } else {
      emit(state.copyWith(getAlertsState: RequestState.error));
    }
  }

  // *** view alert
  Future viewAlert(alertId, {context}) async {
    // emit(state.copyWith(viewAlertState: RequestState.loading));
    var request = http.MultipartRequest(
        'POST', Uri.parse('${ApiConstants.baseUrl}/alerts/view-Alert'));
    request.fields
        .addAll({'alertId': alertId.toString(), 'uniq': AppModel.uniqPhone});

    http.StreamedResponse response = await request.send();
    if (kDebugMode) {
      print("${response.statusCode} ======> viewAlert");
    }
    if (response.statusCode == 200) {
      // emit(state.copyWith(viewAlertState: RequestState.loaded));
      // getCarts(isState: false);
      getAlerts(context: context,page: 1);
      HomeCubit.get(context).getHomeUser(context: context);

    } else {
      emit(state.copyWith(viewAlertState: RequestState.error));
    }
  }
}
