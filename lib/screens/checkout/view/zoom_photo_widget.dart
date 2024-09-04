import 'dart:io';

import 'package:express/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';


import '../../../common_widgtets/alert_dialog.dart';

openAndZoomImageWithurl({context, String? url, dummy = false}) {
  AlertDialogs.showDialog(
      context: Get.context!,
      widget: Stack(
        children: [
          Center(
            child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10)),
                height: Get.height * 0.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    children: [
                      PhotoView(
                        minScale: PhotoViewComputedScale.covered,
                        maxScale: PhotoViewComputedScale.covered,
                        loadingBuilder: (context, event) => Center(
                            child: CircularProgressIndicator(
                          backgroundColor: KColors.primaryColor,
                          color: Colors.white,
                        )),
                        imageProvider: FileImage(File(url!)),
                        // NetworkImage(
                        //     dummy == true ? url! : "${domain}${url ?? ""}"),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: KColors.primaryColor,
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.clear_rounded,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ));
}
