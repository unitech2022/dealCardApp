import 'dart:convert';
import 'package:deal_card/core/enums/loading_status.dart';
import 'package:deal_card/core/helpers/helper_functions.dart';
import 'package:deal_card/core/local_database/local_database.dart';
import 'package:deal_card/core/utils/api_constatns.dart';
import 'package:deal_card/core/utils/utils.dart';
import 'package:deal_card/models/base_response.dart';
import 'package:deal_card/models/city_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  MarketCubit() : super(const MarketState());

  static MarketCubit get(context) => BlocProvider.of<MarketCubit>(context);

  Map<int, int> fav = {};

  List<MarketResponse> markets = [];

  int currentPage = 1;

  int totalPages = 1;
  CityModel? currentCity;
  changCurrentCity(CityModel newValue){
   emit(state.copyWith(currentCity: newValue));

  }

  changeCityId(int newValue){
    emit(state.copyWith(cityId: newValue));
  }

  // ** get markets By fieldId
  Future getMarketsByFieldId({context, cityId, page,fieldId}) async {
    fav.clear();
    if (page == 1) {
      markets = [];
      emit(const MarketState(getMarketsState: RequestState.loading));
    } else {

      emit(const MarketState(getMarketsState: RequestState.pagination));
    }
    bool hasInternetResult = await hasInternet();

    if (hasInternetResult) {
      var request = http.Request(
          'GET',
          Uri.parse(
              '${ApiConstants.baseUrl}/Market/get-Markets?fieldId=$fieldId&page=$page&cityId=$cityId'));

      http.StreamedResponse response = await request.send();

      if (kDebugMode) {
        print("${response.statusCode}=======> getMarketsByFieldId");
      }
      if (response.statusCode == 200) {
        String jsonDataString = await response.stream.bytesToString();
        final jsonData = jsonDecode(jsonDataString);
        BaseResponse baseResponse = BaseResponse.fromJson(jsonData);
        currentPage = baseResponse.currentPage;
        totalPages = baseResponse.totalPages;
        markets.addAll(baseResponse.items);

        await getFavoraits();

        emit(MarketState(
            response: baseResponse, getMarketsState: RequestState.loaded));
      } else {
        emit(const MarketState(getMarketsState: RequestState.error));
      }
    } else {
      emit(const MarketState(getMarketsState: RequestState.noInternet));
    }
  }

  // ** get markets By CategoryId

  Future getMarketsByCategoryId({context,cityId, id, page}) async {
    if (page == 1) {
      markets = [];
      emit(const MarketState(getMarketsState: RequestState.loading));
    } else {
      emit(const MarketState(getMarketsState: RequestState.pagination));
    }
    bool hasInternetResult = await hasInternet();
    emit(const MarketState(getMarketsState: RequestState.loading));
    if (hasInternetResult) {
      var request = http.Request(
          'GET',
          Uri.parse(
              '${ApiConstants.baseUrl}/Market/get-Markets-by-catId?page=$page&categoryId=$id&cityId=$cityId'));

      http.StreamedResponse response = await request.send();

      if (kDebugMode) {
        print("${response.statusCode}=======> getMarketsByCategoryId");
      }
      if (response.statusCode == 200) {
        String jsonDataString = await response.stream.bytesToString();
        final jsonData = jsonDecode(jsonDataString);
        BaseResponse baseResponse = BaseResponse.fromJson(jsonData);
        currentPage = baseResponse.currentPage;
        totalPages = baseResponse.totalPages;
        markets.addAll(baseResponse.items);

        emit(MarketState(
            response: baseResponse, getMarketsState: RequestState.loaded));
      } else {
        emit(const MarketState(getMarketsState: RequestState.error));
      }
    } else {
      emit(const MarketState(getMarketsState: RequestState.noInternet));
    }
  }

  Future getMarketDetails({marketId}) async {
    emit(state.copyWith(getMarketDitealsState: RequestState.loading));
    var request = http.MultipartRequest(
        'GET',
        Uri.parse(ApiConstants.baseUrl +
            '/Market/get-Market-byId?marketId=$marketId'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonDataString);
      MarketResponse marketResponse = MarketResponse.fromJson(jsonData);
      emit(state.copyWith(
          getMarketDitealsState: RequestState.loaded,
          marketResponse: marketResponse));
    } else {
      emit(state.copyWith(getMarketDitealsState: RequestState.error));
    }
  }

  Future addToFave(MarketTable table) async {
    fav.addAll({table.marketId: table.marketId});
    emit(state.copyWith(addFavState: RequestState.loading));
    await LocalDatabaseHelper()
        .insert(MarketTable(
                id: table.id,
                marketId: table.marketId,
                nameAr: table.nameAr,
                nameEng: table.nameEng,
                abouteAr: table.abouteAr,
                abouteEng: table.abouteEng,
                phone: table.phone,
                link: table.link,
                images: table.images,
                email: table.email,
                logoImage: table.logoImage,
                imageCard: table.imageCard,
                cardIds: table.cardIds)
            .toMap())
        .then((value) async {
      print(value);
      // if (value == 0) {
      //   await  getFavoraits();
      //   print("addToFave");
      // } else {
      //   fav.remove(table.marketId);
      // }
      showToast(msg: "تم الإضافة من المفضلة".tr());
      emit(state.copyWith(addFavState: RequestState.loaded));
    });
  }

  Future removeToFave(int marketId) async {
    fav.remove(marketId);
    emit(state.copyWith(addFavState: RequestState.loading));
    await LocalDatabaseHelper().delete(marketId).then((value) async {
      print(value);
      // if (value == 0) {
      //   await  getFavoraits();
      //   print("removeToFave");
      // } else {
      //   fav.addAll({marketId: marketId});
      // }
      showToast(msg: "تم الحذف من المفضلة".tr());
      emit(state.copyWith(addFavState: RequestState.loaded));
    });
  }

  Future getFavoraits() async {
    await LocalDatabaseHelper().queryAllRows().then((value) {
      value.forEach((element) {
        print(element["marketId"]);
        fav.addAll({element["marketId"].toInt(): element["marketId"]});
      });
    });
  }
}
