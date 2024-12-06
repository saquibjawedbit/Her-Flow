
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GlobalVariable {
 static toast(BuildContext context, String msg){
   DelightToastBar(
      snackbarDuration: Duration(milliseconds: 900),
      autoDismiss: true,
       builder: (context){
       return ToastCard(title: Text(msg,
        style:  TextStyle(
           fontWeight: FontWeight.w700,
           fontSize: 14
       ),
       ),
       );
     }
   ).show(context);
 }
}