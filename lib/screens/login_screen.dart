import 'package:blog_app/components/rounded_button.dart';
import 'package:blog_app/screens/forgot_password_screen.dart';
import 'package:blog_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/foundation.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _globalKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber[700],
          title: Text(
            "User Log-In",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Log-In",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
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
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                          ),
                          hintText: "Password",
                          labelText: 'Password',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          return value!.isEmpty ? "Enter your passward" : null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ForgotPassword()));
                          },
                          child: const Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: const Align(
                                alignment: Alignment.centerRight,
                                child: const Text('Forgot the password')),
                          )),
                      const SizedBox(
                        height: 35,
                      ),
                      RoundedButton(
                          title: 'Log-In',
                          onPress: () async {
                            if (_globalKey.currentState!.validate()) {
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                UserCredential user =
                                    await _auth.signInWithEmailAndPassword(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text);

                                if (user != null) {
                                  print("Successful");
                                  toastMessage("User is successfully login");
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                                }
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
