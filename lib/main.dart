import 'package:dynamsoft_capture_vision_flutter/dynamsoft_capture_vision_flutter.dart';
import 'package:express/check_login_notifier.dart';
import 'package:express/common_services/shared_preference.dart';
import 'package:express/screens/camera_permission.dart';
import 'package:express/screens/scanning_view/view/scanning_view.dart';
import 'package:express/screens/splash/view/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_bugfender/flutter_bugfender.dart';

bool permission = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService().init();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  // FlutterBugfender.init("KEzv7x82j5z3CohA9NauoeSNUqZDSbNo");
  var status = await Permission.camera.status;

  if (!status.isGranted) {
    print("denied");
    permission = false;
  } else {
    print("given");
    permission = true;
  }
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  bool isSplash = SharedPreferencesService().getSplashViewed();

  const String licenseKey =
      'DLS2eyJoYW5kc2hha2VDb2RlIjoiMzkwNzUxLTEwMjIzNTQ3NyIsIm1haW5TZXJ2ZXJVUkwiOiJodHRwczovL21sdHMuZHluYW1zb2Z0LmNvbS8iLCJvcmdhbml6YXRpb25JRCI6IjM5MDc1MSIsInN0YW5kYnlTZXJ2ZXJVUkwiOiJodHRwczovL3NsdHMuZHluYW1zb2Z0LmNvbS8iLCJjaGVja0NvZGUiOi0xNzQ0MTUyNTgxfQ==';

  // Initialize the license so that you can use full feature of the Barcode Reader module.
  try {
    await DCVBarcodeReader.initLicense(licenseKey);
  } catch (e) {
    print(e);
  }
  runApp(ProviderScope(
      child: MyApp(
    iSplash: isSplash,
    permission: permission,
  )));
}

class MyApp extends ConsumerStatefulWidget {
  final bool iSplash;
  final bool permission;

  MyApp({super.key, required this.iSplash, required this.permission});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final loginCheckProvider =
      ChangeNotifierProvider.autoDispose<LoginCheckNotifier>((ref) {
    return LoginCheckNotifier();
  });

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(loginCheckProvider).checkLogin();

      Wakelock.enable();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: false,
        builder: (_, child) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: GetMaterialApp(
              title: 'Express',
              home: widget.iSplash
                  ? widget.permission
                      ? BarcodeScanner()
                      : CheckCameraPermission()
                  : SplashView(),
              debugShowCheckedModeBanner: false,
            ),
          );
        });
  }
}
