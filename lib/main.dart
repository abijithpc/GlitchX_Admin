import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/Core/admins_itlites.dart';
import 'package:glitchx_admin/features/Auth/LoginPage/Presentation/Bloc/auth_bloc.dart';
import 'package:glitchx_admin/Splash_Screen/Presentation/splash_screen.dart';
import 'package:glitchx_admin/Core/di.dart' as di;
import 'package:glitchx_admin/features/Category_Page/Presentation/Bloc/category_bloc.dart';
import 'package:glitchx_admin/features/Home_Page/Presentation/Bloc/revenue_bloc.dart';
import 'package:glitchx_admin/features/Orders_Page/Presentation/Bloc/order_bloc.dart';
import 'package:glitchx_admin/features/Product_Page/Presentation/Bloc/product_bloc.dart';
import 'package:glitchx_admin/features/User_Page/Presentation/Bloc/user_bloc.dart';
import 'package:glitchx_admin/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart'; // 👈 Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  await migrateOrderedAtToTimestamp();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider<CategoryBloc>(create: (context) => di.sl<CategoryBloc>()),
        BlocProvider<ProductBloc>(create: (context) => di.sl<ProductBloc>()),
        BlocProvider(create: (context) => di.sl<UserBloc>()),
        BlocProvider(create: (context) => di.sl<OrderBloc>()),
        BlocProvider(create: (context) => di.sl<RevenueBloc>()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splashscreen(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        MonthYearPickerLocalizations.delegate, // 👈 Important
      ],
      supportedLocales: const [
        Locale('en'), // 👈 You can add more locales if needed
      ],
    );
  }
}
