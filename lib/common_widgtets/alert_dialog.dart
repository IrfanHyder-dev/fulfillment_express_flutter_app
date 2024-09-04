
import 'package:flutter/material.dart';

class AlertDialogs {
  static showDialog({required BuildContext context, required Widget widget, barrierDismissible = true}) {
    return showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(builder: (context, setState) {
          return SafeArea(
              child: Material(
                  type: MaterialType.transparency,
                  child: Align(alignment: Alignment.center, child: widget)));
        });
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  static showDialogNoAnimation({context, widget, bool barrierDismissible = true}) {
    return showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(builder: (context, setState) {
          return SafeArea(
              child: Material(
                  type: MaterialType.transparency,
                  child: Align(alignment: Alignment.center, child: widget)));
        });
      },

    );
  }
}