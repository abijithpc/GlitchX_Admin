import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReleaseDatePicker extends StatelessWidget {
  final DateTime? releaseDate;
  final VoidCallback onTap;

  const ReleaseDatePicker({
    required this.releaseDate,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "Release Date",
          prefixIcon: const Icon(CupertinoIcons.calendar),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        child: Text(
          releaseDate != null
              ? DateFormat.yMMMd().format(releaseDate!)
              : "Tap to pick a date",
          style: TextStyle(
            color: releaseDate != null
                ? CupertinoColors.black
                : CupertinoColors.systemGrey,
          ),
        ),
      ),
    );
  }
}