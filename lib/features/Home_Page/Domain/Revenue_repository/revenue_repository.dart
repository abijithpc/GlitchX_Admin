import 'package:glitchx_admin/features/Home_Page/Domain/Model/revenue_model.dart';

abstract class RevenueRepository {
  Future<Map<String, double>> getRevenueByDay();
  Future<Map<String, double>> getRevenueByMonth();
  Future<Map<String, double>> getRevenueByYear();
  Future<int> getOrderCount();
  Future<int> getTotalQuantitySold();
  Future<List<RevenueModel>> getOrdersInRange(DateTime from, DateTime to);
  Future<int> getTotalQuantityInRange(DateTime from, DateTime to);
}
