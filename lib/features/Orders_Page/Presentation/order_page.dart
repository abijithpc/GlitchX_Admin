import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/Core/Widgets/ScreenBackground/screen_background.dart';
import 'package:glitchx_admin/features/Orders_Page/Presentation/Bloc/order_bloc.dart';
import 'package:glitchx_admin/features/Orders_Page/Presentation/Bloc/order_event.dart';
import 'package:glitchx_admin/features/Orders_Page/Presentation/Bloc/order_state.dart';
import 'package:glitchx_admin/features/Orders_Page/Presentation/widget/order_card.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(FetchOrderEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order Management",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.read<OrderBloc>().add(FetchOrderEvent()),
            icon: Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: ScreenBackGround(
        widget: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderStatusUpdating) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrdersLoadedState) {
              final orders = state.orders;
              if (orders.isEmpty) {
                return const Center(child: Text("No orders found."));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return OrderCard(order, context);
                },
              );
            } else if (state is OrderStatusError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return const SizedBox.shrink();
          },
        ),
        screenHeight: screenHeight,
        screenWidth: screenWidth,
      ),
    );
  }
}
