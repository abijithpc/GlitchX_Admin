import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  final File? imageFile;
  final List<String> imageUrls;
  final Function(File) onImagePicked;

  const ImagePickerWidget({
    Key? key,
    required this.imageFile,
    required this.imageUrls,
    required this.onImagePicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _imagePicker = ImagePicker();

    return GestureDetector(
      onTap: () async {
        final image = await _imagePicker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          onImagePicked(File(image.path));
        }
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image:
                  imageFile != null
                      ? DecorationImage(
                        image: FileImage(imageFile!),
                        fit: BoxFit.cover,
                      )
                      : (imageUrls.isNotEmpty
                          ? DecorationImage(
                            image: NetworkImage(imageUrls.first),
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
}
