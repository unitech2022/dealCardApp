
import 'package:deal_card/models/market_model.dart';
import 'package:deal_card/models/user_response.dart';
import 'package:equatable/equatable.dart';
class OrderResponseDetails{
  final UserModel? userModel;
  final MarketModel? market;
  final Order? order;
  const OrderResponseDetails(
      {required this.market,
        required this.userModel,
        required this.order,
       });
  factory OrderResponseDetails.fromJson(Map<String, dynamic> json) => OrderResponseDetails(
    order: Order.fromJson(json["order"]),
    market:MarketModel.fromJson(json["market"]) ,
    userModel: UserModel.fromJson(json["user"]),
);
}

class Order extends Equatable {
  final int id;
  final int marketId;
  final int status;

  final String userId;
  final String timeOrder;

  final String desc;
  final String createdAt;

  const Order(
      {required this.id,
        required this.marketId,
      required this.status,
      required this.userId,
      required this.desc,
      required this.timeOrder,
      required this.createdAt});

  factory Order.fromJson(Map<String, dynamic> json) => Order(
      id: json["id"],
      marketId: json["marketId"],
      status: json["status"],
      userId: json["userId"],
      desc: json["desc"]??"",
      createdAt: json["createdAt"], timeOrder: json["timeOrder"],);


  @override
  List<Object?> get props => [
        id,
        marketId,
        status,
        userId,
        desc,
    timeOrder,

        createdAt,

      ];
}
