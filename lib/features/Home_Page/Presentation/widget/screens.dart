import 'package:flutter/material.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/category_page.dart';
import 'package:glitchx_admin/features/Home_Page/Presentation/dashboard_page.dart';
import 'package:glitchx_admin/features/Orders_Page/Presentation/order_page.dart';
import 'package:glitchx_admin/features/Product_Page/Presentation/screens/product_page.dart';
import 'package:glitchx_admin/features/User_Page/Presentation/pages/user_page.dart';

List<Widget> screens = const [
  DashboardPage(),
  UserPage(),
  AdminOrdersPage(),
  CategoryPage(),
  ProductPage(),
];
