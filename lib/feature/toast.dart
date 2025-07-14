import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showCustomToast(BuildContext context, String msg1, String msg2, String msg3, String msg4) {
  FToast fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.black87,
    ),
    child: RichText(
      text: TextSpan(
        text: msg1,
        style: TextStyle(color: Colors.white, fontSize: 16),
        children: [
          TextSpan(
            text: msg2,
            style: TextStyle(color: const Color.fromARGB(255, 54, 202, 215), fontSize: 16),
          ),
          TextSpan(
            text: msg3,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          TextSpan(
            text: msg4,
            style: TextStyle(color: const Color.fromARGB(255, 54, 202, 215), fontSize: 16),
          ),
        ],
      ),
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 2),
  );
}
