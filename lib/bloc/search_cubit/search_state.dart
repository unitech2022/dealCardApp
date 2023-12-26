part of 'search_cubit.dart';



class SearchState extends Equatable {
  final  List<MarketResponse>? response;

  final RequestState? getSearchMarketsState;

  const SearchState({this.response, this.getSearchMarketsState});

  @override
  // TODO: implement props
  List<Object?> get props => [response,getSearchMarketsState];
}
