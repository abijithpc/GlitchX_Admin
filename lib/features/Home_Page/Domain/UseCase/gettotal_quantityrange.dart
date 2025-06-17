import 'package:glitchx_admin/features/Home_Page/Domain/Revenue_repository/revenue_repository.dart';

class GetTotalQuantityInRangeUseCase {
  final RevenueRepository repository;

  GetTotalQuantityInRangeUseCase(this.repository);

  Future<int> call(DateTime from, DateTime to) {
    return repository.getTotalQuantityInRange(from, to);
  }
}
