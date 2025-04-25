import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Presentation/Bloc/auth_bloc.dart';
import 'package:glitchx_admin/SplashScreen/Presentation/splash_screen.dart';
import 'package:glitchx_admin/Core/di.dart' as di;
import 'package:glitchx_admin/features/Category_Page/Presentation/Bloc/category_bloc.dart';
import 'package:glitchx_admin/features/HomePage/Presentation/Bloc/home_bloc.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/add_productpage.dart';
import 'package:glitchx_admin/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (context) => di.sl<HomeBloc>()),
        BlocProvider(
          create: (context) => di.sl<CategoryBloc>(),
          child: AddProductPage(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Splashscreen(), debugShowCheckedModeBanner: false);
  }
}
