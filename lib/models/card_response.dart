import 'package:deal_card/models/card_model.dart';
import 'package:deal_card/models/subscribe_model.dart';
import 'package:deal_card/models/user_response.dart';

class CardResponse {
  final List<CardList> cards;

  final UserModel? userDetailResponse;


  CardResponse(
      {required this.cards,
      required this.userDetailResponse,
     });

  factory CardResponse.fromJson(Map<String, dynamic> json) => CardResponse(
      cards: List<CardList>.from(
          (json["cards"] as List).map((e) => CardList.fromJson(e))),

      userDetailResponse:json["user"]!=null? UserModel.fromJson(json["user"]):null
      
      );
}

class CardList {
  final CardModel? card;
  final SubscribeModel? subscription;

  final bool isSSubscribe;

  CardList(
      {required this.card,

        required this.subscription,
        required this.isSSubscribe});

  factory CardList.fromJson(Map<String, dynamic> json) => CardList(
      card:json["card"] !=null ? CardModel.fromJson(json["card"]) : null,
      subscription: json["subscription"] != null
          ? SubscribeModel.fromJson(json["subscription"])
          : null,
      isSSubscribe: json["isSSubscribe"],


  );
}