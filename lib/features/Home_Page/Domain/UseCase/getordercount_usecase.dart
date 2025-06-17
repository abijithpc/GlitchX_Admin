import 'package:glitchx_admin/features/Home_Page/Domain/Revenue_repository/revenue_repository.dart';

class GetOrderCountUseCase {
  final RevenueRepository repository;

  GetOrderCountUseCase(this.repository);

  Future<int> call() async {
    return await repository.getOrderCount();
  }
}
