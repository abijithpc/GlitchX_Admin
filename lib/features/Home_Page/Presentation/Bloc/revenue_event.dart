abstract class RevenueEvent {}

class LoadRevenueByDay extends RevenueEvent {}

class LoadRevenueByMonth extends RevenueEvent {}

class LoadRevenueByYear extends RevenueEvent {}

class LoadTotalSoldQuantity extends RevenueEvent {}

class LoadOrderCount extends RevenueEvent {}

class LoadRevenueInRange extends RevenueEvent {
  final DateTime fromDate;
  final DateTime toDate;

  LoadRevenueInRange({required this.fromDate, required this.toDate});
}
