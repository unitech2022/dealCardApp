part of 'market_cubit.dart';

class MarketState extends Equatable {
  final BaseResponse? response;

  final RequestState? getMarketsState;
  final RequestState? addFavState;
  final RequestState? getFavState;
  final CityModel? currentCity;
  final int cityId;

  final RequestState? getMarketDitealsState;
  final MarketResponse? marketResponse;

  const MarketState(
      {this.response,
      this.getMarketsState,
        this.currentCity,
      this.addFavState,
        this.cityId=0,
      this.getFavState,
      this.getMarketDitealsState,
      this.marketResponse});

  MarketState copyWith(
          {final BaseResponse? response,
          final RequestState? getMarketsState,
          final RequestState? addFavState,
            final CityModel? currentCity,
          final RequestState? getFavState,
            final int? cityId,
            final RequestState? getMarketDitealsState,
            final MarketResponse? marketResponse}) =>
      MarketState(
        response: response ?? this.response,
        cityId: cityId ?? this.cityId,
        currentCity: currentCity ?? this.currentCity,
        getFavState: getFavState ?? this.getFavState,
        getMarketsState: getMarketsState ?? this.getMarketsState,
        addFavState: addFavState ?? this.addFavState,
        getMarketDitealsState: getMarketDitealsState ?? this.getMarketDitealsState,
        marketResponse: marketResponse ?? this.marketResponse,
      );

  @override
  List<Object?> get props =>
      [response, getMarketsState, addFavState, getFavState,marketResponse,getMarketDitealsState,cityId,currentCity];
}
