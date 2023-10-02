import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gigX/constant/constants.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  String? imagePath;
  ImageViewer({
    this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      body: Stack(
        children: [
          Container(
              child: PhotoView(
            imageProvider: FileImage(File(imagePath!)),
          )),
          // Positioned(
          //     top: 40,
          //     left: 20,
          //     child: InkWell(
          //       onTap: () {
          //         Get.back();
          //       },
          //       child: Icon(
          //         Icons.arrow_back_ios,
          //         color: whiteColor,
          //       ),
          //     ))
        ],
      ),
    );
  }
}
