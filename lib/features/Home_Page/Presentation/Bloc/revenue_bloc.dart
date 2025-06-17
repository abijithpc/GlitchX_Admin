import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/Model/revenue_model.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/UseCase/getorder_range_usecase.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/UseCase/getordercount_usecase.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/UseCase/getrevenue_bymonthusecase.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/UseCase/getrevenueday_usecase.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/UseCase/getrevenueyear_usecase.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/UseCase/gettotal_quantityrange.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/UseCase/gettotaquantity_usecase.dart';
import 'package:glitchx_admin/features/Home_Page/Presentation/Bloc/revenue_event.dart';
import 'package:glitchx_admin/features/Home_Page/Presentation/Bloc/revenue_state.dart';

class RevenueBloc extends Bloc<RevenueEvent, RevenueState> {
  final GetRevenueByDayUseCase getRevenueByDayUseCase;
  final GetRevenueByMonthUseCase getRevenueByMonthUseCase;
  final GetRevenueByYearUseCase getRevenueByYearUseCase;
  final GetTotalSoldQuantityUseCase quantityUseCase;
  final GetOrderCountUseCase countUseCase;
  final GetOrdersInRangeUseCase ordersInRangeUseCase;
  final GetTotalQuantityInRangeUseCase totalQuantityInRangeUseCase;

  RevenueBloc({
    required this.getRevenueByDayUseCase,
    required this.getRevenueByMonthUseCase,
    required this.getRevenueByYearUseCase,
    required this.quantityUseCase,
    required this.countUseCase,
    required this.ordersInRangeUseCase,
    required this.totalQuantityInRangeUseCase,
  }) : super(RevenueInitial()) {
    Map<String, double> groupByDate(List<RevenueModel> orders) {
      final Map<String, double> map = {};

      for (var order in orders) {
        final key =
            "${order.orderedAt.year}-${order.orderedAt.month.toString().padLeft(2, '0')}-${order.orderedAt.day.toString().padLeft(2, '0')}";
        map[key] = (map[key] ?? 0) + order.price;
      }

      return map;
    }

    on<LoadRevenueByDay>((event, emit) async {
      emit(RevenueLoading());
      try {
        final data = await getRevenueByDayUseCase();
        final total = await quantityUseCase();
        final count = await countUseCase();

        emit(RevenueLoaded(data, total, count));
      } catch (e) {
        emit(RevenueError(e.toString()));
      }
    });

    on<LoadRevenueByMonth>((event, emit) async {
      emit(RevenueLoading());
      try {
        final data = await getRevenueByMonthUseCase();
        final total = await quantityUseCase();
        final count = await countUseCase();

        emit(RevenueLoaded(data, total, count));
      } catch (e) {
        emit(RevenueError(e.toString()));
      }
    });

    on<LoadRevenueByYear>((event, emit) async {
      emit(RevenueLoading());
      try {
        final data = await getRevenueByYearUseCase();
        final total = await quantityUseCase();
        final count = await countUseCase();
        print("Fetched raw data: ${data.entries}");

        emit(RevenueLoaded(data, total, count));
      } catch (e) {
        emit(RevenueError(e.toString()));
      }
    });

    on<LoadTotalSoldQuantity>((event, emit) async {
      emit(RevenueLoading());
      try {
        final total = await quantityUseCase();
        final data = await getRevenueByYearUseCase();
        final count = await countUseCase();

        emit(RevenueLoaded(data, total, count));
      } catch (e) {
        emit(RevenueError("Failed to load quantity: $e"));
      }
    });

    on<LoadOrderCount>((event, emit) async {
      emit(RevenueLoading());
      try {
        final count = await countUseCase();
        final total = await quantityUseCase();
        final data = await getRevenueByYearUseCase();
        emit(RevenueLoaded(data, total, count));
      } catch (e) {
        emit(RevenueError(e.toString()));
      }
    });
    on<LoadRevenueInRange>((event, emit) async {
      emit(RevenueLoading());

      try {
        final fromUtc = event.fromDate.toUtc();
        final toUtc =
            DateTime(
              event.toDate.year,
              event.toDate.month,
              event.toDate.day,
              23,
              59,
              59,
            ).toUtc();

        final orders = await ordersInRangeUseCase(fromUtc, toUtc);
        print("✅ Orders fetched: ${orders.length}");
        for (final o in orders) {
          print("Amount: ₹${o.price} | Date: ${o.orderedAt}");
        }

        final revenueData = groupByDate(orders);
        final totalQuantity = await totalQuantityInRangeUseCase(fromUtc, toUtc);
        final orderCount = orders.length;
        print("🧾 RevenueData: $revenueData");
        print("📦 Total Quantity: $totalQuantity");
        print("📊 Order Count: $orderCount");
        

        emit(RevenueLoaded(revenueData, totalQuantity, orderCount));
      } catch (e) {
        emit(RevenueError("Error loading range data: $e"));
      }
    });
  }
}
