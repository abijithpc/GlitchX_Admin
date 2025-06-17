import 'package:glitchx_admin/features/Home_Page/Domain/Revenue_repository/revenue_repository.dart';

class GetTotalSoldQuantityUseCase {
  final RevenueRepository repository;

  GetTotalSoldQuantityUseCase(this.repository);

  Future<int> call() async {
    return await repository.getTotalQuantitySold();
  }
}
