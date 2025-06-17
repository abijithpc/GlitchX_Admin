abstract class OrderEvent {}

class ChangeOrderStatusEvent extends OrderEvent {
  final String orderId;
  final String newStatus;

  ChangeOrderStatusEvent({required this.orderId, required this.newStatus});
}

class FetchOrderEvent extends OrderEvent {}
