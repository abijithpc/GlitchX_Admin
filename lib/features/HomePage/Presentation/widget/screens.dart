import 'package:flutter/material.dart';
import 'package:glitchx_admin/features/Category_Page/Presentation/category_page.dart';
import 'package:glitchx_admin/features/HomePage/Presentation/dashboard_page.dart';
import 'package:glitchx_admin/features/Orders_Page/Presentation/order_page.dart';
import 'package:glitchx_admin/features/ProductPage/Presentation/product_page.dart';

List<Widget> screens = const [
  DashboardPage(),
  OrderPage(),
  CategoryPage(),
  ProductPage(),
];
