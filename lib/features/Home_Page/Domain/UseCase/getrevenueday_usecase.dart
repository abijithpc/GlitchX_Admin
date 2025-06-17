import 'package:glitchx_admin/features/Home_Page/Domain/Revenue_repository/revenue_repository.dart';

class GetRevenueByDayUseCase {
  final RevenueRepository repository;
  GetRevenueByDayUseCase(this.repository);

  Future<Map<String, double>> call() async {
    return repository.getRevenueByDay();
  }
}
