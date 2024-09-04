import 'package:express/common_widgtets/custom_text.dart';
import 'package:express/common_widgtets/status_bar_widget.dart';
import 'package:express/screens/signin_with_passcode/notifier/signin_passcode_notifier.dart';
import 'package:express/screens/signin_with_passcode/widget/asterisk_widget.dart';
import 'package:express/utils/colors.dart';
import 'package:express/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInPasscodeView extends ConsumerStatefulWidget {
  @override
  ConsumerState<SignInPasscodeView> createState() => _SignInPasscodeView();
}

class _SignInPasscodeView extends ConsumerState<SignInPasscodeView> {
  final passcodeProvider =
      ChangeNotifierProvider<SignInPasscodeNotifier>((ref) {
    return SignInPasscodeNotifier();
  });

  @override
  Widget build(BuildContext context) {
    final passcodeNotifier = ref.watch(passcodeProvider);
    final double width = MediaQuery.of(context).size.height;
    final double height = MediaQuery.of(context).size.width;
    print('height height $height');
    return StatusBarWidget(
      child: Scaffold(
        extendBodyBehindAppBar: false,
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              fit: BoxFit.cover,
              opacity: 0.2,
              image: AssetImage('assets/images/passcode_bg.jpg'),
            ),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 200.verticalSpace,
                (height * 0.53).verticalSpace,
                CustomText(
                    text: 'Enter Passcode',
                    textStyle: KTextStyles().medium(fontSize: 16)),
                AsteriskWidget(listLength: passcodeNotifier.result.length),
                const SizedBox(height: 15),
                Container(
                  // height: 350,
                  height: height * 0.99,
                  // width: 250,
                  // color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of columns
                        crossAxisSpacing: 10, // Spacing between columns
                        mainAxisSpacing: 1, // Spacing between rows
                        // mainAxisExtent: 80
                      ),
                      itemCount: passcodeNotifier.numPad.length,
                      // Number of items in the grid
                      itemBuilder: (context, index) {
                        String value = passcodeNotifier.numPad[index];

                        return SizedBox(
                          child: InkWell(
                            onTap: () {
                              if (passcodeNotifier.loading == false) {
                                passcodeNotifier.buttonOnTap(value);
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: value == "done"
                                      ? KColors.primaryColor
                                      : null,
                                  border: Border.all(
                                      color: value == "done"
                                          ? KColors.primaryColor
                                          : Colors.white),
                                  shape: BoxShape.circle),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              child: value == "done"
                                  ? const Icon(Icons.check, color: Colors.black)
                                  : value == "remove"
                                      ? const Icon(Icons.clear,
                                          color: KColors.primaryColor)
                                      : Text(
                                          value,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.bold),
                                        ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Spacer(),
                if (passcodeNotifier.loading)
                  Center(
                    child: CircularProgressIndicator(
                      color: KColors.primaryColor,
                    ),
                  ),
                Spacer(),
              ]),
        ),
      ),
    );
  }
}
