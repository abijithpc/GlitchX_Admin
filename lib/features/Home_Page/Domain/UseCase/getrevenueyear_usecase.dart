import 'package:glitchx_admin/features/Home_Page/Domain/Revenue_repository/revenue_repository.dart';

class GetRevenueByYearUseCase {
  final RevenueRepository repository;
  GetRevenueByYearUseCase(this.repository);

  Future<Map<String, double>> call() async {
    return repository.getRevenueByYear();
  }
}

