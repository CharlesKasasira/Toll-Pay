import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

//colors
const kTinGrey = Color(0xFF909090);
const ksecondary = Color(0xff1a1a1a);
const kGreen = Color(0xff005620);

const kNunitoSansSemiBold18 = TextStyle(
  fontFamily: "NunitoSans",
  fontSize: 18,
  color: kGreen,
  fontWeight: FontWeight.w600,
);

/// Simple preloader inside a Center widget
const preloader = Center(child: CircularProgressIndicator(color: Colors.black));

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        elevation: 6,
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        // width: 280.0,
      ),
    );
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }

  void showSuccessSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.green);
  }
}

Future kDefaultDialog(String title, String message,
    {VoidCallback? onYesPressed}) async {
  if (GetPlatform.isIOS) {
    await Get.dialog(
      CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (onYesPressed != null)
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "Cancel",
              ),
            ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: onYesPressed,
            child: Text(
              (onYesPressed == null) ? "Ok" : "Yes",
            ),
          ),
        ],
      ),
    );
  } else {
    await Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (onYesPressed != null)
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Color(0xFFEB5757),
                ),
              ),
            ),
          TextButton(
            onPressed: (onYesPressed == null)
                ? () {
                    Get.back();
                  }
                : onYesPressed,
            child: Text(
              (onYesPressed == null) ? "Ok" : "Yes",
              style: const TextStyle(
                color: Color(0xff1a1a1a),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const inputDecorationConst = InputDecoration(
  isDense: true,
  floatingLabelBehavior: FloatingLabelBehavior.never,
  labelStyle: TextStyle(
    fontFamily: "NunitoSans",
    color: kTinGrey,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: ksecondary),
  ),
);
