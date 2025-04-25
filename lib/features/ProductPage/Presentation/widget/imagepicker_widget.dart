import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImagePickerWidget extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onPickImage;

  const ImagePickerWidget({
    required this.imageFile,
    required this.onPickImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPickImage,
      child: DottedBorder(
        color: CupertinoColors.activeBlue,
        strokeWidth: 2,
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        dashPattern: [6, 3],
        child: Container(
          height: 180,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: imageFile != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 180,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      CupertinoIcons.photo_on_rectangle,
                      size: 40,
                      color: CupertinoColors.activeBlue,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Tap to upload image",
                      style: TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}