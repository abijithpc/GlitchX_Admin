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
import 'package:glitchx_admin/features/Category_Page/Domain/UseCase/get_category_usecase.dart';
import 'package:glitchx_admin/features/Category_Page/Domain/category_repository/category_repository.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/Bloc/category_bloc.dart';
import 'package:glitchx_admin/features/HomePage/Presentation/Bloc/home_bloc.dart';
import 'package:glitchx_admin/features/ProductPage/Data/ProductRepositoryImpl/product_repositoryimpl.dart';
import 'package:glitchx_admin/features/ProductPage/Data/Product_RemoteDatasource/product_data_remotesource.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/Product_repository/product_repository.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/UseCase/delete_usecase.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/UseCase/edit_usecase.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/UseCase/get_product_usecase.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/UseCase/update_profile_image_usecase.dart';
import 'package:glitchx_admin/features/ProductPage/Domain/UseCase/uploadproduct_usecase.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_bloc.dart';

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

  //Bloc
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(adminLoginUsecase: sl(), checkAuthStatusUseCase: sl()),
  );
  sl.registerFactory(() => HomeBloc());

  sl.registerFactory(() => CategoryBloc(addCategory: sl(), getCategory: sl()));

  sl.registerFactory(
    () => ProductBloc(
      getProductUsecase: sl(),
      productUsecase: sl(),
      deleteProductUsecase: sl(),
      editProductUsecase: sl(),
      updateProductImageUsecase: sl(),
    ),
  );
}
