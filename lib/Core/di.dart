import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Data/AuthRepositoryImpl/auth_repository_impl.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Data/Auth_RemoteDatasource/auth_remote_datasource.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Domain/Auth_repository/auth_repository.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Domain/UseCase/admin_login_usecase.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Domain/UseCase/check_auth_status.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Presentation/Bloc/auth_bloc.dart';
import 'package:glitchx_admin/features/Category_Page/Data/CategoryRepositoryImpl/category_repositoryimpl.dart';
import 'package:glitchx_admin/features/Category_Page/Data/Category_RemoteDatasource/category_remotedatasource.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/UseCase/addcategory_usecase.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/UseCase/delete_category_usecase.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/UseCase/edit_category_usecase.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/UseCase/get_category_usecase.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/category_repository/category_repository.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/Bloc/category_bloc.dart';
import 'package:glitchx_admin/features/Home_Page/Data/Revenue_RemoteDatasource/revenue_remotedatasoource.dart';
import 'package:glitchx_admin/features/Home_Page/Data/Revenue_RepositoryImpl/revenue_repo_impl.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/Revenue_repository/revenue_repository.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/UseCase/getorder_range_usecase.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/UseCase/getordercount_usecase.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/UseCase/getrevenue_bymonthusecase.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/UseCase/getrevenueday_usecase.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/UseCase/getrevenueyear_usecase.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/UseCase/gettotal_quantityrange.dart';
import 'package:glitchx_admin/features/Home_Page/Domain/UseCase/gettotaquantity_usecase.dart';
import 'package:glitchx_admin/features/Home_Page/Presentation/Bloc/revenue_bloc.dart';
import 'package:glitchx_admin/features/Orders_Page/Data/OrderRepositoryImpl/order_repositoryimpl.dart';
import 'package:glitchx_admin/features/Orders_Page/Data/Order_RemoteDatasource/order_remotedatasource.dart';
import 'package:glitchx_admin/features/Orders_Page/Domain/UseCase/fetch_order_usecase.dart';
import 'package:glitchx_admin/features/Orders_Page/Domain/UseCase/order_usecase.dart';
import 'package:glitchx_admin/features/Orders_Page/Domain/order_repository/order_repository.dart';
import 'package:glitchx_admin/features/Orders_Page/Presentation/Bloc/order_bloc.dart';
import 'package:glitchx_admin/features/Product_Page/Data/ProductRepositoryImpl/product_repositoryimpl.dart';
import 'package:glitchx_admin/features/Product_Page/Data/Product_RemoteDatasource/product_data_remotesource.dart';
import 'package:glitchx_admin/features/Product_Page/Domain/Product_repository/product_repository.dart';
import 'package:glitchx_admin/features/Product_Page/Domain/UseCase/delete_usecase.dart';
import 'package:glitchx_admin/features/Product_Page/Domain/UseCase/edit_usecase.dart';
import 'package:glitchx_admin/features/Product_Page/Domain/UseCase/get_product_usecase.dart';
import 'package:glitchx_admin/features/Product_Page/Domain/UseCase/update_profile_image_usecase.dart';
import 'package:glitchx_admin/features/Product_Page/Domain/UseCase/uploadproduct_usecase.dart';
import 'package:glitchx_admin/features/Product_Page/Presentation/Bloc/product_bloc.dart';
import 'package:glitchx_admin/features/User_Page/Data/User_RemoteDatasource/user_dataremotesource.dart';
import 'package:glitchx_admin/features/User_Page/Data/User_RepositoryImpl/user_reposiotryimpl.dart';
import 'package:glitchx_admin/features/User_Page/Domain/UseCase/blockuser_usecase.dart';
import 'package:glitchx_admin/features/User_Page/Domain/UseCase/get_user_usecase.dart';
import 'package:glitchx_admin/features/User_Page/Domain/UseCase/unblocuser_usecase.dart';
import 'package:glitchx_admin/features/User_Page/Domain/User_repository/user_repository.dart';
import 'package:glitchx_admin/features/User_Page/Presentation/Bloc/user_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //FireStorage
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  //Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  //FireStore
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  //Data Source
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasource(sl()),
  );

  sl.registerLazySingleton<CategoryRemotedatasource>(
    () => CategoryRemotedatasource(firestore: sl()),
  );

  sl.registerLazySingleton<ProductDataRemotesource>(
    () => ProductDataRemotesource(firestore: sl(), storage: sl()),
  );
  sl.registerLazySingleton<UserDataremotesource>(
    () => UserDataremotesource(sl()),
  );
  sl.registerLazySingleton<OrderRemotedatasource>(
    () => OrderRemotedatasource(sl()),
  );
  sl.registerLazySingleton<RevenueRemoteDataSource>(
    () => RevenueRemoteDataSource(sl()),
  );
  //repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryimpl(sl()),
  );

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryimpl(productDataRemotesource: sl()),
  );
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryimpl(sl()));
  sl.registerLazySingleton<RevenueRepository>(
    () => RevenueRepositoryImpl(sl()),
  );

  //UseCase
  sl.registerLazySingleton(() => AdminLoginUsecase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => AddcategoryUsecase(sl()));
  sl.registerLazySingleton(() => GetCategoryUsecase(sl()));
  sl.registerLazySingleton(() => UploadproductUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetProductUsecase(productRepository: sl()));
  sl.registerLazySingleton(() => DeleteProductUsecase(sl()));
  sl.registerLazySingleton(() => EditProductUsecase(sl()));
  sl.registerLazySingleton(() => EditProductImageUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCategoryUsecase(repository: sl()));
  sl.registerLazySingleton(
    () => UpdateCategoryUsecase(categoryRepository: sl()),
  );
  sl.registerLazySingleton(() => GetUsersUseCase(sl()));
  sl.registerLazySingleton(() => BlockUserUseCase(sl()));
  sl.registerLazySingleton(() => UnblockUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateOrderStatusUsecase(sl()));
  sl.registerLazySingleton(() => FetchOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetRevenueByDayUseCase(sl()));
  sl.registerLazySingleton(() => GetRevenueByMonthUseCase(sl()));
  sl.registerLazySingleton(() => GetRevenueByYearUseCase(sl()));
  // sl.registerLazySingleton(() => GetPaidOrderCount(sl()));
  sl.registerLazySingleton(() => GetTotalSoldQuantityUseCase(sl()));
  sl.registerLazySingleton(() => GetOrderCountUseCase(sl()));
  sl.registerLazySingleton(() => GetOrdersInRangeUseCase(sl()));
  sl.registerLazySingleton(() => GetTotalQuantityInRangeUseCase(sl()));

  //Bloc
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(adminLoginUsecase: sl(), checkAuthStatusUseCase: sl()),
  );
  // sl.registerFactory(() => HomeBloc());

  sl.registerFactory(
    () => CategoryBloc(
      updateCategory: sl(),
      addCategory: sl(),
      getCategory: sl(),
      deleteCategory: sl(),
    ),
  );

  sl.registerFactory(
    () => ProductBloc(
      getProductUsecase: sl(),
      productUsecase: sl(),
      deleteProductUsecase: sl(),
      editProductUsecase: sl(),
      updateProductImageUsecase: sl(),
    ),
  );
  sl.registerFactory(() => UserBloc(sl(), sl(), sl()));
  sl.registerFactory(() => OrderBloc(sl(), sl()));
  sl.registerFactory(
    () => RevenueBloc(
      countUseCase: sl(),
      // getPaidOrdersCountUseCase: sl(),
      getRevenueByDayUseCase: sl(),
      getRevenueByMonthUseCase: sl(),
      getRevenueByYearUseCase: sl(),
      quantityUseCase: sl(),
      ordersInRangeUseCase: sl(),
      totalQuantityInRangeUseCase: sl(),
    ),
  );
}
