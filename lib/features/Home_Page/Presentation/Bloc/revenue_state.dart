
abstract class RevenueState {}

class RevenueInitial extends RevenueState {}

class RevenueLoading extends RevenueState {}

class RevenueLoaded extends RevenueState {
  final Map<String, double> revenueData;
  final int totalQuantity;
  final int orderCount;

  RevenueLoaded(this.revenueData, this.totalQuantity, this.orderCount);
}

class RevenueError extends RevenueState {
  final String message;
  RevenueError(this.message);
}

// class TotalSoldQuantityLoaded extends RevenueState {
//   final int totalQuantity;
//    TotalSoldQuantityLoaded(this.totalQuantity);
// }
