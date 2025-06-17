import 'package:glitchx_admin/features/Home_Page/Domain/Model/revenue_model.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/Revenue_repository/revenue_repository.dart';

class GetOrdersInRangeUseCase {
  final RevenueRepository repository;

  GetOrdersInRangeUseCase(this.repository);

  Future<List<RevenueModel>> call(DateTime from, DateTime to) {
    return repository.getOrdersInRange(from, to);
  }
}
