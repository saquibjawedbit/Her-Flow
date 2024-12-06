import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:her_flow/screens/authentication/signin_screen.dart';
import 'package:her_flow/screens/methods.dart';

import '../../theme/theme.dart';
import '../../widgets/custom_scaffold.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  String dropdownvalue_user = "one";
  String dropdowvalue_gender = "one";
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController location = TextEditingController();
  bool visible =false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final userdatabaseref = FirebaseDatabase.instance.ref("user");
   final doctordatabaseref = FirebaseDatabase.instance.ref("doctor");


   @override
  void dispose() {
    // TODO: implement dispose
     name.dispose();
     email.dispose();
     age.dispose();
     password.dispose();
     bio.dispose();
     location.dispose();
    super.dispose();
  }



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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                DropdownButton<String>(
                    icon: Icon(Icons.supervised_user_circle_rounded,size:60,color: Colors.white,),
                    style: TextStyle(color: Colors.black),

                    value: dropdownvalue_user,
                    items:[
                      DropdownMenuItem<String>(
                        value: 'one',
                        child:  Container(
                          child: Text('User'),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'two',
                        child:  Container(
                          child: Text('Doctor'),
                        ),
                      ),
                    ] ,
                    onChanged: (String? value){
                      setState(() {
                        dropdownvalue_user = value!;
                      });
                    }
                ),
                Spacer(),
                DropdownButton<String>(
                    icon: Icon(Icons.person,size: 60,color: Colors.white,),
                    style: TextStyle(color: Colors.black),

                    value: dropdowvalue_gender,
                    items:[
                      DropdownMenuItem<String>(
                        value: 'one',
                        child:  Container(
                          child: Text('Male'),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'two',
                        child:  Container(
                          child: Text('Femail'),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'three',
                        child:  Container(
                          child: Text('other'),
                        ),
                      ),
                    ] ,
                    onChanged: (String? valuee){
                      setState(() {
                        dropdowvalue_gender = valuee!;
                      });
                    }
                ),
              ],
            ),
          ),


          Expanded(


            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                // get started form
                child:  getform()
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getform(){
    if(dropdownvalue_user == "one"){
      return Form(
        key: _formSignupKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // get started text

            const SizedBox(
              height: 40.0,
            ),
            // full name
            SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Full name';
                        }
                        return null;
                      },
                      controller: name,
                      decoration: InputDecoration(
                        label: const Text('Full Name'),
                        hintText: 'Enter Full Name',
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
                    // email
                    TextFormField(
                      controller: email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Email';
                        }
                        final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
                        if(!emailValid){
                          return 'write correct Email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text('Email'),
                        hintText: 'Enter Email',
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

                    TextFormField(
                      controller: age,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter age';
                        }
                        return null;
                      },
                      decoration: InputDecoration(

                        label: const Text('Age'),
                        hintText: 'Enter Age',
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


                    // password
                    TextFormField(

                      controller: password,

                      obscureText: visible,
                      obscuringCharacter: '*',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(visible
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(
                                  () {
                                visible  = !visible;
                              },
                            );
                          },
                        ),
                        label: const Text('Password'),
                        hintText: 'Enter Password',
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
                  ],
                )
            ),
            const SizedBox(
              height: 25.0,
            ),
            // i agree to the processing

            const SizedBox(
              height: 25.0,
            ),
            // signup button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ()  {
                  if(_formSignupKey.currentState!.validate()){
                    _auth.createUserWithEmailAndPassword(email: email.text.toString(), password: password.text.toString()).then((value) {

                      String? idd = _auth.currentUser?.uid;
                      //String id = DateTime.now().microsecondsSinceEpoch.toString();

                      String gender  = dropdowvalue_gender;

                      userdatabaseref.child(idd.toString()).set({
                        'name': name.text.toString(),
                        'age' : age.text.toString(),
                        'gender' : gender,
                        'subscription' : '0',
                        'useridd' : idd,
                      }).then((value) {
                        GlobalVariable.toast(context, "Account Created Successfully");

                      }).onError((error, stackTrace) {
                        GlobalVariable.toast(context, error.toString());
                      });


                    }).onError((error, stackTrace) {
                      GlobalVariable.toast(context, error.toString());

                    });
                  }

                },
                child: const Text('Sign up'),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            // sign up divider
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.7,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),

                Expanded(
                  child: Divider(
                    thickness: 0.7,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),

            // already have an account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (e) => const SignInScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: lightColorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      );
    }
    else {
      return  Form(
        key: _formSignupKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // get started text

            const SizedBox(
              height: 40.0,
            ),
            // full name
            SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Full name';
                        }
                        return null;
                      },
                      controller: name,
                      decoration: InputDecoration(
                        label: const Text('Full Name'),
                        hintText: 'Enter Full Name',
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
                    // email
                    TextFormField(
                      controller: email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Email';
                        }
                        final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
                        if(!emailValid){
                          return 'write correct Email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text('Email'),
                        hintText: 'Enter Email',
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


                    TextFormField(
                      controller: age,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter age';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text('Age'),
                        hintText: 'Enter Age',
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

                    TextFormField(
                      controller: location,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Clinic location';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text('location'),
                        hintText: 'Enter clinic location',
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


                    TextFormField(
                      controller: bio,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {

                        if (value == null || value.isEmpty) {
                          return 'Please enter about you';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text('Bio'),
                        hintText: 'Enter Bio',
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

                    // password
                    TextFormField(
                      controller: password,
                      obscureText: visible,
                      obscuringCharacter: '*',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(visible
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(
                                  () {
                                visible  = !visible;
                              },
                            );
                          },
                        ),
                        label: const Text('Password'),
                        hintText: 'Enter Password',
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
                  ],
                )
            ),
            const SizedBox(
              height: 25.0,
            ),
            // i agree to the processing

            const SizedBox(
              height: 25.0,
            ),
            // signup button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                    if(_formSignupKey.currentState!.validate()){
                      _auth.createUserWithEmailAndPassword(email: email.text.toString(), password: password.text.toString()).then((value) {

                        String? idd = _auth.currentUser?.uid;
                        String id = DateTime.now().microsecondsSinceEpoch.toString();

                        String gender  = dropdowvalue_gender;


                        doctordatabaseref.child(idd.toString()).set({
                          'name': name.text.toString(),
                          'age' : age.text.toString(),
                          'bio' : bio.text.toString(),
                          'gender' : gender,
                          'useridd' : idd,
                          'location' : location.text.toString(),
                          'id' : id
                        }).then((value) {
                        GlobalVariable.toast(context, "Account Created Successfully");
                        }).onError((error, stackTrace) {
                          GlobalVariable.toast(context, error.toString());

                        });


                      }).onError((error, stackTrace) {
                        GlobalVariable.toast(context, error.toString());
                      });


                    }


                },
                child: const Text('Sign up'),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            // sign up divider
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.7,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),

                Expanded(
                  child: Divider(
                    thickness: 0.7,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),

            // already have an account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (e) => const SignInScreen(),
                    ),);
                  },
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: lightColorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      );
    }
  }


}