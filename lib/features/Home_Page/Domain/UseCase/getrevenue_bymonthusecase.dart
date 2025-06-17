import 'package:glitchx_admin/features/Home_Page/Domain/Revenue_repository/revenue_repository.dart';

class GetRevenueByMonthUseCase {
  final RevenueRepository repository;
  GetRevenueByMonthUseCase(this.repository);

  Future<Map<String, double>> call() async {
    return repository.getRevenueByMonth();
  }
}
