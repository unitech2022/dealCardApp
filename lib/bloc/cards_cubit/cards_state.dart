part of 'cards_cubit.dart';

class CardsState extends Equatable {
  final CardResponse? cardResponse;

  final List<CardList>? cardsOfMarket;

  final RequestState? getCardsState;



  final RequestState? paymentConfirmState;
  final RequestState? scanCodeState;
  final String paymentMessage;
  const CardsState(
      {this.scanCodeState=RequestState.loading, this.cardsOfMarket, this.cardResponse, this.getCardsState, this.paymentConfirmState,this.paymentMessage="waiting ...."});

  CardsState copyWith(
          {final RequestState? paymentConfirmState,
          final RequestState? getCardsState,
           final String? paymentMessage,
            final RequestState? scanCodeState,
            final List<CardList>? cardsOfMarket,
          final CardResponse? cardResponse}) =>
      CardsState(
        cardsOfMarket: cardsOfMarket ?? this.cardsOfMarket,
        scanCodeState: scanCodeState ?? this.scanCodeState,
        cardResponse: cardResponse ?? this.cardResponse,
        getCardsState: getCardsState ?? this.getCardsState,
              paymentMessage: paymentMessage ?? this.paymentMessage,
        paymentConfirmState: paymentConfirmState ?? this.paymentConfirmState,
      );

  @override
  List<Object?> get props => [cardResponse, getCardsState, paymentConfirmState,paymentMessage,cardsOfMarket,scanCodeState];
}
