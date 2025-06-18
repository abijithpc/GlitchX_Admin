import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProductCalender extends StatelessWidget {
  const EditProductCalender({super.key, required DateTime? releaseDate})
    : _releaseDate = releaseDate;

  final DateTime? _releaseDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(CupertinoIcons.calendar_today, color: Colors.deepPurple),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            _releaseDate == null
                ? 'Select Release Date'
                : DateFormat('dd/MM/yyyy').format(_releaseDate!),
            style: TextStyle(
              color: _releaseDate == null ? Colors.grey[600] : Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
