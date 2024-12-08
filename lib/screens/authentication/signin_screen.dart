import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:her_flow/screens/HomeScreen.dart';
import 'package:her_flow/screens/authentication/forget_password_screen.dart';
import 'package:her_flow/screens/authentication/signup_screen.dart';
import 'package:her_flow/screens/methods.dart';
import 'package:her_flow/screens/chat/userchatscreen.dart';

import '../../theme/theme.dart';
import '../../widgets/custom_scaffold.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  bool visible = true;
  String dropdownvalue_user = "zero";
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loading = false;
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
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      DropdownButton<String>(
                          icon: const Icon(
                            Icons.supervised_user_circle_rounded,
                            size: 60,
                            color: Colors.black,
                          ),
                          style: const TextStyle(color: Colors.black),
                          value: dropdownvalue_user,
                          items: [
                            DropdownMenuItem<String>(
                              value: 'zero',
                              child: Container(
                                child: Text('None'),
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: 'one',
                              child: Container(
                                child: Text('User'),
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: 'two',
                              child: Container(
                                child: Text('Doctor'),
                              ),
                            ),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              dropdownvalue_user = value!;
                            });
                          }),
                      const SizedBox(
                        height: 25,
                      ),

                      TextFormField(
                        controller: email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
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
                                  visible = !visible;
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
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const ForgetScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Forget password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      _loginBtn(),
                      const SizedBox(
                        height: 25.0,
                      ),
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
                        height: 25.0,
                      ),

                      const SizedBox(
                        height: 25.0,
                      ),
                      // don't have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign up',
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginBtn() {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          loading = true;
        });

        if (_formSignInKey.currentState!.validate()) {
          _auth
              .signInWithEmailAndPassword(
                  email: email.text.toString(),
                  password: password.text.toString())
              .then((value) {
            setState(() {
              loading = false;
            });
            GlobalVariable.toast(context, "Login Successfully");
            String? id = _auth.currentUser?.uid;

            if (dropdownvalue_user == "one") {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (e) => HomeScreen(),
                  ));
            } else if (dropdownvalue_user == "zero") {
              GlobalVariable.toast(context, "Please enter Correct User Type");
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (e) => ChatScreen(
                      type: 'doctor',
                    ),
                  ));
            }
          }).onError((error, stackTrace) {
            GlobalVariable.toast(context, "${error.toString()}");

            setState(() {
              loading = false;
            });
          });
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: loading
          ? const CircularProgressIndicator()
          : const SizedBox(
              width: double.infinity,
              child: Text(
                "Sign-in ",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              )),
    );
  }
}
