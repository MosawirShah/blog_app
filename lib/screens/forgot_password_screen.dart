import 'package:blog_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/rounded_button.dart';
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _globalKey = GlobalKey<FormState>();
  String? email;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber[700],
          title: const Text(
            "Forgot Password",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 28.0, horizontal: 30),
              child: Form(
                  key: _globalKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                          hintText: "Email",
                          labelText: 'Email',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          return value!.isEmpty ? "Enter your email" : null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      RoundedButton(
                          title: 'Recover Password',
                          onPress: () async {
                            if (_globalKey.currentState!.validate()) {
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                _auth.sendPasswordResetEmail(email: _emailController.text).then((value) {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  toastMessage("Please check your email, a reset link has been sent.");
                                }).onError((error, stackTrace){
                                  toastMessage(error.toString());
                                  setState(() {
                                    showSpinner = false;
                                  });
                                });

                              } catch (e) {
                                print(e.toString());
                                toastMessage(e.toString());
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            }
                          }),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black45,
        fontSize: 16.0);
  }
}
