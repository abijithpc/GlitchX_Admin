import 'package:glitchx_admin/features/Home_Page/Data/Revenue_RemoteDatasource/revenue_remotedatasoource.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/Model/revenue_model.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/Revenue_repository/revenue_repository.dart';

class RevenueRepositoryImpl implements RevenueRepository {
  final RevenueRemoteDataSource remoteDataSource;

  RevenueRepositoryImpl(this.remoteDataSource);

  @override
  Future<Map<String, double>> getRevenueByDay() async {
    final orders = await remoteDataSource.fetchPaidOrders();

    Map<String, double> revenueByDay = {};

    for (var order in orders) {
      final key =
          "${order.orderedAt.year}-${order.orderedAt.month.toString().padLeft(2, '0')}-${order.orderedAt.day.toString().padLeft(2, '0')}";

      revenueByDay[key] = (revenueByDay[key] ?? 0) + order.price;
    }

    return revenueByDay;
  }

  @override
  Future<Map<String, double>> getRevenueByMonth() async {
    final orders = await remoteDataSource.fetchPaidOrders();

    Map<String, double> revenueByMonth = {};

    for (var order in orders) {
      final key =
          "${order.orderedAt.year}-${order.orderedAt.month.toString().padLeft(2, '0')}";

      revenueByMonth[key] = (revenueByMonth[key] ?? 0) + order.price;
    }

    return revenueByMonth;
  }

  @override
  Future<Map<String, double>> getRevenueByYear() async {
    final orders = await remoteDataSource.fetchPaidOrders();

    Map<String, double> revenueByYear = {};

    for (var order in orders) {
      final key = "${order.orderedAt.year}";

      revenueByYear[key] = (revenueByYear[key] ?? 0) + order.price;
    }

    return revenueByYear;
  }

  @override
  Future<int> getOrderCount() {
    return remoteDataSource.getOrderCount();
  }

  @override
  Future<int> getTotalQuantitySold() {
    return remoteDataSource.getTotalQuantitySold();
  }

  @override
  Future<List<RevenueModel>> getOrdersInRange(DateTime from, DateTime to) {
    return remoteDataSource.getOrdersInRange(from, to);
  }

  @override
  Future<int> getTotalQuantityInRange(DateTime from, DateTime to) {
    return remoteDataSource.getTotalQuantityInRange(from, to);
  }
}
