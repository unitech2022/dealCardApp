import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:deal_card/core/enums/loading_status.dart';
import 'package:deal_card/core/helpers/helper_functions.dart';
import 'package:deal_card/core/utils/api_constatns.dart';
import 'package:deal_card/core/utils/app_model.dart';
import 'package:deal_card/models/city_model.dart';
import 'package:deal_card/models/home_response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  static HomeCubit get(context) => BlocProvider.of<HomeCubit>(context);

  // ** get home User
  Future getHomeUser({context}) async {
    bool hasInternetResult = await hasInternet();
    emit(state.copyWith(getHomeState: RequestState.loading));
    if (hasInternetResult) {
      var request = http.Request(
          'GET', Uri.parse('${ApiConstants.baseUrl}/home/get-home-data?unniq=${AppModel.uniqPhone}'));

      http.StreamedResponse response = await request.send();

      if (kDebugMode) {
        print("${response.statusCode}=======> getHome");
      }
      if (response.statusCode == 200) {
        String jsonDataString = await response.stream.bytesToString();
        final jsonData = jsonDecode(jsonDataString);

        HomeResponse homeResponse = HomeResponse.fromJson(jsonData);
        print("callUsNumber"+homeResponse.callUsNumber.valueAr);
        AppModel.cities = homeResponse.cities;
        AppModel.cities.insert(0, CityModel(id: 0, nameAr: "الكل", nameEng: "All"));
        emit(state.copyWith(
            getHomeState: RequestState.loaded, homeResponse: homeResponse));
      } else {
        emit(state.copyWith(getHomeState: RequestState.error));
      }
    } else {
      emit(state.copyWith(getHomeState: RequestState.noInternet));
    }
  }

  changeCurrentIndexNav(int newIndex) {
    emit(state.copyWith(currentNavIndex: newIndex));
  }
}
