import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/Core/Widgets/ScreenBackground/screen_background.dart';
import 'package:glitchx_admin/Core/admins_itlites.dart';
import 'package:glitchx_admin/features/Home_Page/Presentation/Bloc/revenue_bloc.dart';
import 'package:glitchx_admin/features/Home_Page/Presentation/Bloc/revenue_event.dart';
import 'package:glitchx_admin/features/Home_Page/Presentation/widget/dashboard_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<RevenueBloc>().add(LoadRevenueByDay());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () async {
        //     await migrateOrderedAtToTimestamp();
        //     ScaffoldMessenger.of(
        //       context,
        //     ).showSnackBar(SnackBar(content: Text('Migration completed')));
        //   },
        //   icon: Icon(Icons.mode_night_sharp, color: Colors.white),
        // ),
        title: const Text(
          "📊 Revenue Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed:
                () => context.read<RevenueBloc>().add(LoadRevenueByDay()),
            icon: Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: ScreenBackGround(
        widget: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [dashboardwidget()]),
        ),
        screenHeight: screenHeight,
        screenWidth: screenWidth,
      ),
    );
  }
}
