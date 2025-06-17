import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glitchx_admin/features/Home_Page/Presentation/Bloc/revenue_bloc.dart';
import 'package:glitchx_admin/features/Home_Page/Presentation/Bloc/revenue_event.dart';
import 'package:month_year_picker/month_year_picker.dart';

Future<void> showMonthRangePicker(BuildContext context) async {
  DateTime now = DateTime.now();
  DateTime? startMonth;
  DateTime? endMonth;

  await showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('Select Month Range'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                final picked = await showMonthYearPicker(
                  context: context,
                  initialDate: now,
                  firstDate: DateTime(2023),
                  lastDate: now,
                );
                if (picked != null) {
                  startMonth = picked;
                }
              },
              child: const Text("Pick Start Month"),
            ),
            ElevatedButton(
              onPressed: () async {
                final picked = await showMonthYearPicker(
                  context: context,
                  initialDate: startMonth ?? now,
                  firstDate: startMonth ?? DateTime(2023),
                  lastDate: now,
                );
                if (picked != null) {
                  endMonth = picked;
                }
              },
              child: const Text("Pick End Month"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (startMonth != null && endMonth != null) {
                if (endMonth!.isBefore(startMonth!)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("End month must be after start month"),
                    ),
                  );
                  return;
                }

                final firstDay = DateTime(
                  startMonth!.year,
                  startMonth!.month,
                  1,
                );
                final lastDay = DateTime(
                  endMonth!.year,
                  endMonth!.month + 1,
                  0,
                );

                context.read<RevenueBloc>().add(
                  LoadRevenueInRange(fromDate: firstDay, toDate: lastDay),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Loading revenue from ${startMonth!.month}/${startMonth!.year} to ${endMonth!.month}/${endMonth!.year}",
                    ),
                  ),
                );
              }
            },
            child: const Text("Done"),
          ),
        ],
      );
    },
  );
}

Widget monthRangeButton(BuildContext context) {
  return ElevatedButton.icon(
    onPressed: () {
      showMonthRangePicker(context); // ✅ Proper usage
    },
    icon: const Icon(Icons.date_range),
    label: const Text("Month Range"),
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );
}
