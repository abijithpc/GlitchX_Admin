import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/features/Home_Page/Presentation/Bloc/revenue_bloc.dart';
import 'package:glitchx_admin/features/Home_Page/Presentation/Bloc/revenue_event.dart';
import 'package:glitchx_admin/features/Home_Page/Presentation/Bloc/revenue_state.dart';
import 'package:glitchx_admin/features/Home_Page/Presentation/widget/daterange_button.dart';
import 'package:glitchx_admin/features/Home_Page/Presentation/widget/revenue_chart.dart';

Expanded dashboardwidget() {
  return Expanded(
    child: BlocBuilder<RevenueBloc, RevenueState>(
      builder: (context, state) {
        if (state is RevenueLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RevenueLoaded) {
          print("Revenue Data :${state.revenueData}");
          if (state.revenueData.isEmpty) {
            return const Center(
              child: Text(
                "No revenue data found.",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          double totalRevenue = state.revenueData.values.fold(
            0.0,
            (sum, value) => sum + (value ?? 0.0),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔹 Filters (By Day, Month, Year, and Date Range)
              Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _filterButton(context, "By Day", LoadRevenueByDay()),
                  _filterButton(context, "By Month", LoadRevenueByMonth()),
                  _filterButton(context, "By Year", LoadRevenueByYear()),
                  _dateRangeButton(context),
                  monthRangeButton(context),
                ],
              ),

              const SizedBox(height: 16),

              // 🔹 Summary Cards
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _summaryCard(
                    "Total Revenue",
                    "₹$totalRevenue",
                    Icons.attach_money,
                  ),
                  _summaryCard(
                    "Product Sold",
                    "${state.totalQuantity}",
                    Icons.shopping_cart,
                  ),
                  _summaryCard(
                    "Orders",
                    "${state.orderCount}",
                    Icons.bar_chart,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🔹 Chart Label
              const Padding(
                padding: EdgeInsets.only(left: 12.0, bottom: 12),
                child: Text(
                  "📈 Revenue Overview",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),

              // 🔹 Bar Chart
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: BarChart(buildBarChartData(state.revenueData)),
                ),
              ),
            ],
          );
        } else if (state is RevenueError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return const Center(
          child: Text('Please select a filter to view data.'),
        );
      },
    ),
  );
}

// 🔹 Filter Buttons
Widget _filterButton(BuildContext context, String label, RevenueEvent event) {
  return ElevatedButton.icon(
    onPressed: () => context.read<RevenueBloc>().add(event),
    icon: const Icon(Icons.filter_alt),
    label: Text(label),
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );
}

// 🔹 New: Date Range Picker Button
Widget _dateRangeButton(BuildContext context) {
  return ElevatedButton.icon(
    onPressed: () async {
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2023),
        lastDate: DateTime.now(),
      );

      if (picked != null) {
        context.read<RevenueBloc>().add(
          LoadRevenueInRange(fromDate: picked.start, toDate: picked.end),
        );
      }
    },
    icon: const Icon(Icons.date_range),
    label: const Text("Date Range"),
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );
}

// 🔹 Summary Cards
Widget _summaryCard(String title, String value, IconData icon) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Icon(icon, size: 28, color: Colors.blue),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.amber,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
