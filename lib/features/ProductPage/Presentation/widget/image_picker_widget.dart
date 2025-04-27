// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:glitchx_admin/features/ProductPage/Presentation/Bloc/product_bloc.dart';
// import 'package:image_picker/image_picker.dart';

// class ImagePickerWidget extends StatefulWidget {
//   final String? imageUrl;
//   const ImagePickerWidget({Key? key, this.imageUrl}) : super(key: key);

//   @override
//   State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
// }

// class _ImagePickerWidgetState extends State<ImagePickerWidget> {
//   File? _pickerImage;

//   Future<void> _pickeImage() async{
//     final picker =ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile !=null) {
//       final file =File(pickedFile.path);
//       context.read<ProductBloc>().add(upla);
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {}, // Later you can add image change functionality
//       child: Stack(
//         children: [
//           Container(
//             width: double.infinity,
//             height: 200,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               image: DecorationImage(
//                 image:
//                     widget.imageUrl != null
//                         ? NetworkImage(widget.imageUrl!)
//                         : const AssetImage('assets/images/placeholder.png')
//                             as ImageProvider,
//                 fit: BoxFit.cover,
//               ),
//               color: Colors.grey.withAlpha(77),
//             ),
//           ),
//           Positioned(
//             bottom: 12,
//             right: 12,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                   color: Colors.black.withAlpha(66),
//                   child: const Text(
//                     'Change Image',
//                     style: TextStyle(color: Colors.white, fontSize: 14),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
