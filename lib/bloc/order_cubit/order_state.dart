part of 'order_cubit.dart';

class OrderState extends Equatable {
  final RequestState? addOrderState;
  final RequestState? deleteOrderState;
  final RequestState? getOrderDetailsState;
  final RequestState? getOrdersState;
  final RequestState? addTimeOrderState;
  final OrderResponseDetails? orderResponseDetails;
  final List<ScanResponse> scanns;

  final List<Order> orders;
  final int currentIndexTap;
  final String timeOrder;

  const OrderState({
    this.orders = const [],
    this.addOrderState,
    this.orderResponseDetails,
    this.deleteOrderState,
    this.getOrderDetailsState,
    this.currentIndexTap = 0,
    this.getOrdersState,
    this.addTimeOrderState,
    this.timeOrder = "",
    this.scanns=const[],
  });

  OrderState copyWith(
          { final List<ScanResponse>? scanns,
            final RequestState? addOrderState,
          final RequestState? deleteOrderState,
          final RequestState? getOrderDetailsState,
          final RequestState? getOrdersState,
          final int? currentIndexTap,
          final RequestState? addTimeOrderState,
          final List<Order>? orders,
          final String? timeOrder,
          final OrderResponseDetails? orderResponseDetails}) =>
      OrderState(
        scanns: scanns ?? this.scanns,
        addOrderState: addOrderState ?? this.addOrderState,
        deleteOrderState: deleteOrderState ?? this.deleteOrderState,
        getOrderDetailsState: getOrderDetailsState ?? this.getOrderDetailsState,
        getOrdersState: getOrdersState ?? this.getOrdersState,
        currentIndexTap: currentIndexTap ?? this.currentIndexTap,
        orders: orders ?? this.orders,
        addTimeOrderState: addTimeOrderState ?? this.addTimeOrderState,
        timeOrder: timeOrder ?? this.timeOrder,
        orderResponseDetails: orderResponseDetails ?? this.orderResponseDetails,
      );

  @override
  List<Object?> get props => [
    scanns,
        deleteOrderState,
        addOrderState,
        getOrderDetailsState,
        currentIndexTap,
        getOrdersState,
        orders,
        addTimeOrderState,
        timeOrder,
        orderResponseDetails
      ];
}
