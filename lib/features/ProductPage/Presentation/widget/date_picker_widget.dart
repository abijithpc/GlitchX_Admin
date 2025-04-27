import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<DateTime?> pickReleaseDate(BuildContext context, DateTime? initialDate) {
  return showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.deepPurple),
        ),
        child: child!,
      );
    },
  );
}

Widget buildDatePickerTile(DateTime? releaseDate) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    decoration: BoxDecoration(
      color: Colors.white.withAlpha(128),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.deepPurple.withAlpha(38),
          blurRadius: 8,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Row(
      children: [
        const Icon(CupertinoIcons.calendar_today, color: Colors.deepPurple),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            releaseDate == null ? 'Select Release Date' : DateFormat('dd/MM/yyyy').format(releaseDate),
            style: TextStyle(
              color: releaseDate == null ? Colors.grey[600] : Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
      ],
    ),
  );
}

void showSuccessDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('Product Updated'),
      content: const Text('Your changes have been saved successfully!'),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('OK'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}
