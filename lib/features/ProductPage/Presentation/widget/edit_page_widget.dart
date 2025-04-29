import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

Widget buildTextField({
  required String label,
  required IconData icon,
  required TextEditingController controller,
  TextInputType type = TextInputType.text,
}) {
  return AnimatedOpacity(
    opacity: 1,
    duration: const Duration(milliseconds: 500),
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(128),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withAlpha(38),
            blurRadius: 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: type,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              decoration: InputDecoration(
                hintText: label,
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildImagePicker({
  required Function onTap,
  required String? imageUrl,
  required File? imageFile,
}) {
  return GestureDetector(
    onTap: () async {
      await onTap();
    },
    child: Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: imageFile != null
                ? DecorationImage(
                    image: FileImage(imageFile),
                    fit: BoxFit.cover,
                  )
                : (imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: AssetImage('assets/images/placeholder.png'),
                        fit: BoxFit.cover,
                      )),
            color: Colors.grey.withAlpha(77),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: Colors.black.withAlpha(66),
                child: const Text(
                  'Change Image',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildDatePicker({
  required DateTime? releaseDate,
  required Function onTap,
}) {
  return GestureDetector(
    onTap: () async {
      await onTap();
    },
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
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
          Icon(
            CupertinoIcons.calendar_today,
            color: Colors.deepPurple,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              releaseDate == null
                  ? 'Select Release Date'
                  : DateFormat(
                      'dd/MM/yyyy',
                    ).format(releaseDate),
              style: TextStyle(
                color: releaseDate == null ? Colors.grey[600] : Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
