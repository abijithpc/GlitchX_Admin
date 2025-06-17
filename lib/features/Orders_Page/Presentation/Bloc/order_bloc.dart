import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/features/Orders_Page/Domain/UseCase/fetch_order_usecase.dart';
import 'package:glitchx_admin/features/Orders_Page/Domain/UseCase/order_usecase.dart';
import 'package:glitchx_admin/features/Orders_Page/Presentation/Bloc/order_event.dart';
import 'package:glitchx_admin/features/Orders_Page/Presentation/Bloc/order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final UpdateOrderStatusUsecase _statusUsecase;
  final FetchOrdersUseCase _ordersUseCase;

  OrderBloc(this._statusUsecase, this._ordersUseCase) : super(OrderInitial()) {
    on<ChangeOrderStatusEvent>((event, emit) async {
      emit(OrderStatusUpdating());
      try {
        // Update order status
        await _statusUsecase(event.orderId, event.newStatus);

        // After successful update, fetch updated list of orders
        final updatedOrders = await _ordersUseCase();

        // Emit loaded state with updated orders
        emit(OrdersLoadedState(updatedOrders));
      } catch (e) {
        emit(OrderStatusError(e.toString()));
      }
    });

    on<FetchOrderEvent>((event, emit) async {
      emit(OrderStatusUpdating());
      try {
        final orders = await _ordersUseCase();
        print("Orders fetched: ${orders.length}");

        emit(OrdersLoadedState(orders));
      } catch (e) {
        emit(OrderStatusError(e.toString()));
      }
    });
  }
}
