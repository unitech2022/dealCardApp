import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:deal_card/core/utils/app_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../../core/enums/loading_status.dart';
import '../../core/helpers/helper_functions.dart';
import '../../core/utils/api_constatns.dart';
import '../../models/base_response.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchState());

  static SearchCubit get(context) => BlocProvider.of<SearchCubit>(context);

  Future getMarketsSearched({context, text}) async {
    emit(const SearchState(getSearchMarketsState: RequestState.loading));

    bool hasInternetResult = await hasInternet();

    if (hasInternetResult) {
      var request = http.MultipartRequest(
          'POST', Uri.parse('${ApiConstants.baseUrl}/Market/search-Market'));
      request.fields.addAll({
        'textSearch': text,
        'type': AppModel.lang == AppModel.arLang ? "0" : "1",
      });

      http.StreamedResponse response = await request.send();

      if (kDebugMode) {
        print("${response.statusCode}=======> getMarketsByFieldId");
      }
      if (response.statusCode == 200) {
        String jsonDataString = await response.stream.bytesToString();
        final jsonData = jsonDecode(jsonDataString);

        emit(SearchState(
            response: List<MarketResponse>.from(
                (jsonData as List).map((e) => MarketResponse.fromJson(e))),
            getSearchMarketsState: RequestState.loaded));
      } else {
        emit(const SearchState(getSearchMarketsState: RequestState.error));
      }
    } else {
      emit(const SearchState(getSearchMarketsState: RequestState.noInternet));
    }
  }
}
