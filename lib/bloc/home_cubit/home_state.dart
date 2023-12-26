part of 'home_cubit.dart';

 class HomeState extends Equatable {
    final HomeResponse? homeResponse;
    final int currentNavIndex;
  final RequestState getHomeState;
  const HomeState({ this.homeResponse, this.getHomeState=RequestState.loading,this.currentNavIndex=0});

    HomeState copyWith({
      final HomeResponse? homeResponse,
      final int? currentNavIndex,
      final RequestState? getHomeState

    }) =>
        HomeState(
          homeResponse: homeResponse ?? this.homeResponse,
          currentNavIndex: currentNavIndex ?? this.currentNavIndex,
          getHomeState: getHomeState ?? this.getHomeState,


        );

  @override
  List<Object?> get props => [
    homeResponse,
    getHomeState,currentNavIndex
  ];
}
