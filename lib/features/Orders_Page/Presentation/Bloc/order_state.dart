import 'package:glitchx_admin/features/Orders_Page/Domain/Model/orderitems.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderStatusUpdating extends OrderState {}

class OrderStatusUpdated extends OrderState {}

class OrderStatusError extends OrderState {
  final String message;

  OrderStatusError(this.message);
}

class OrdersLoadedState extends OrderState {
  final List<OrderModel> orders;

  OrdersLoadedState(this.orders);
}
