import 'package:express/common_services/shared_preference.dart';
import 'package:express/screens/camera_permission.dart';
import 'package:express/screens/scanning_view/view/scanning_view.dart';
import 'package:express/utils/asset_images.dart';
import 'package:express/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:permission_handler/permission_handler.dart';

final stateProvider = Provider((ref) async {
  await Future.delayed(const Duration(seconds: 3));
  Get.to(() => BarcodeScanner());
});

final permissionCheck = Provider((ref) async {
  await Future.delayed(const Duration(seconds: 3));
  SharedPreferencesService().setSplashView(true);
  var status = await Permission.camera.status;

  if (status.isDenied) {
    // We didn't ask for permission yet or the permission has been denied before, but not permanently.
    Get.offAll(() => CheckCameraPermission());
  } else if (status.isGranted) {
    Get.offAll(() => BarcodeScanner());
  }

// You can can also directly ask the permission about its status.
});

class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(permissionCheck);
    return Scaffold(
      backgroundColor: KColors.primaryColor,
      body: Center(
        child: SizedBox(
          height: 322.h,
          child: Image.asset(
            AssetImages.logo,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
