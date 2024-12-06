import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_scaffold.dart';
import '../methods.dart';


class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  TextEditingController email  = TextEditingController();
  final _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        child: Column(
        children: [
        const Expanded(
        flex: 1,
        child: SizedBox(
        height: 10,
    ),
    ),
    Expanded(
    flex: 7,
    child: Container(
    padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
    decoration: const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
    topLeft: Radius.circular(40.0),
    topRight: Radius.circular(40.0),
    ),
    ),
      child: Column(
        children: [

          TextFormField(
            controller: email,

            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter email';
              }
              return null;
            },
            decoration: InputDecoration(

              label: const Text('Recovery Email'),
              hintText: 'Enter Recovery Email',
              hintStyle: const TextStyle(
                color: Colors.black26,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12, // Default border color
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black12, // Default border color
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),



      const SizedBox(
        height: 25.0,
      ),
      // signup button
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async{
            if(email!=null){
              await _auth.sendPasswordResetEmail(
                  email: email.text.toString()).then((value) {
                GlobalVariable.toast(context, "Link Sent to Email for Password Reset");
                Navigator.pop(context);

              }).onError((error, stackTrace) {
                GlobalVariable.toast(context, error.toString());
              });
            }else{
              GlobalVariable.toast(context, "Enter email Correctly");
            }



          },
          child: const Text('Recover Email'),
        ),
      ),


      ],
    )
    )
    )
    ]
    )
    );
  }
}
